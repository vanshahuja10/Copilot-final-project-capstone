$ErrorActionPreference = 'Stop'

function Get-PropertyValue {
	param($Object, [string[]]$Names)

	if ($null -eq $Object) { return $null }
	foreach ($name in $Names) {
		$property = $Object.PSObject.Properties |
			Where-Object { $_.Name -ieq $name } |
			Select-Object -First 1
		if ($null -ne $property) { return $property.Value }
	}
	return $null
}

function Write-Decision {
	param([string]$Decision, [string]$Reason)

	[Console]::Out.WriteLine(([ordered]@{
		permissionDecision = $Decision
		permissionDecisionReason = $Reason
	} | ConvertTo-Json -Compress))
}

function Get-PathCandidates {
	param($Node, [int]$Depth = 0)

	if ($null -eq $Node -or $Depth -gt 16 -or $Node -is [string]) { return }

	if ($Node -is [System.Collections.IDictionary]) {
		foreach ($key in $Node.Keys) {
			$value = $Node[$key]
			if ($key -match '^(filePath|file_path|path|target|targetPath|target_path|uri|file|fileName|filename)$' -and $value -is [string]) {
				Write-Output $value
			}
			else {
				Get-PathCandidates -Node $value -Depth ($Depth + 1)
			}
		}
		return
	}

	if ($Node -is [array]) {
		foreach ($item in $Node) { Get-PathCandidates -Node $item -Depth ($Depth + 1) }
		return
	}

	foreach ($property in $Node.PSObject.Properties) {
		if ($property.Name -match '^(filePath|file_path|path|target|targetPath|target_path|uri|file|fileName|filename)$' -and $property.Value -is [string]) {
			Write-Output $property.Value
		}
		else {
			Get-PathCandidates -Node $property.Value -Depth ($Depth + 1)
		}
	}
}

function Resolve-WorkspaceRelativePath {
	param([string]$PathValue, [string]$BaseDirectory, [string]$WorkspaceRoot)

	$candidate = $PathValue.Trim().Trim([char[]]@([char]34, [char]39))
	if ($candidate -match '^file:') {
		try { $candidate = ([Uri]$candidate).LocalPath }
		catch { return $null }
	}

	try {
		if (-not [IO.Path]::IsPathRooted($candidate)) {
			$candidate = Join-Path $BaseDirectory $candidate
		}
		$fullPath = [IO.Path]::GetFullPath($candidate)
	}
	catch { return $null }

	$rootPrefix = $WorkspaceRoot.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
	if (-not $fullPath.StartsWith($rootPrefix, [StringComparison]::OrdinalIgnoreCase)) { return $null }
	return $fullPath.Substring($rootPrefix.Length).Replace('\', '/')
}

try {
	$rawInput = [Console]::In.ReadToEnd()
	if ([string]::IsNullOrWhiteSpace($rawInput)) {
		Write-Decision 'deny' 'Could not read the Edit/Write tool request; protected artifacts are denied by default.'
		exit 0
	}
	$event = ConvertFrom-Json -InputObject $rawInput -ErrorAction Stop
}
catch {
	Write-Decision 'deny' 'Could not parse the Edit/Write tool request; protected artifacts are denied by default.'
	exit 0
}

$toolName = [string](Get-PropertyValue -Object $event -Names @('toolName', 'tool_name'))
if ($toolName -notmatch '^(?i:Edit|Write|EditFile|WriteFile|edit_file|write_file)$') { exit 0 }

$toolArgs = Get-PropertyValue -Object $event -Names @('toolArgs', 'tool_args', 'toolInput', 'tool_input')
if ($toolArgs -is [string]) {
	try { $toolArgs = ConvertFrom-Json -InputObject $toolArgs -ErrorAction Stop }
	catch {
		Write-Decision 'deny' 'Could not parse Edit/Write arguments; protected artifacts are denied by default.'
		exit 0
	}
}

$pathCandidates = @(Get-PathCandidates -Node $toolArgs)
if ($pathCandidates.Count -eq 0) {
	Write-Decision 'deny' 'Could not identify the Edit/Write target path; protected artifacts are denied by default.'
	exit 0
}

$workspaceRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..\..'))
$baseDirectory = [string](Get-PropertyValue -Object $event -Names @('cwd', 'workingDirectory', 'working_directory'))
if ([string]::IsNullOrWhiteSpace($baseDirectory) -or -not (Test-Path -LiteralPath $baseDirectory -PathType Container)) {
	$baseDirectory = $workspaceRoot
}

$protectedArtifacts = @(
	'requirements.md',
	'architecture.md',
	'design-review.md',
	'implementation-plan.md',
	'code-review.md',
	'verification.md'
)
$protectedTargets = @()
$overridePath = Join-Path $workspaceRoot '.github\hooks\.artifact-override'
$overrideRelativePath = '.github/hooks/.artifact-override'

foreach ($candidate in $pathCandidates) {
	$relativePath = Resolve-WorkspaceRelativePath -PathValue ([string]$candidate) -BaseDirectory $baseDirectory -WorkspaceRoot $workspaceRoot
	if ($null -eq $relativePath) { continue }

	if ($relativePath -ieq $overrideRelativePath) {
		Write-Decision 'deny' 'The override marker is reserved for explicit human creation outside Edit/Write tools.'
		exit 0
	}
	if ($protectedArtifacts -icontains $relativePath) {
		if ($protectedTargets -inotcontains $relativePath) { $protectedTargets += $relativePath }
	}
}

if ($protectedTargets.Count -eq 0) { exit 0 }
if ($protectedTargets.Count -gt 1) {
	Write-Decision 'deny' 'A single-use artifact override can authorize only one protected artifact per Edit/Write call.'
	exit 0
}

if (-not (Test-Path -LiteralPath $overridePath -PathType Leaf)) {
	Write-Decision 'deny' "Modification of '$($protectedTargets[0])' requires a human-created .github/hooks/.artifact-override file. The override is consumed after one allowed modification."
	exit 0
}

try {
	$overrideItem = Get-Item -LiteralPath $overridePath -Force
	if (($overrideItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
		Write-Decision 'deny' 'The artifact override marker must be a regular file, not a link.'
		exit 0
	}
	Remove-Item -LiteralPath $overridePath -Force -ErrorAction Stop
}
catch {
	Write-Decision 'deny' 'The one-time artifact override could not be safely consumed.'
	exit 0
}

Write-Decision 'allow' "Human override consumed for one modification of '$($protectedTargets[0])'."
exit 0
