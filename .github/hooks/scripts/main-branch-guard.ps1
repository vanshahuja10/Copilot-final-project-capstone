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

function Get-CommandValues {
	param($Node, [int]$Depth = 0)

	if ($null -eq $Node -or $Depth -gt 12 -or $Node -is [string]) { return }

	if ($Node -is [System.Collections.IDictionary]) {
		foreach ($key in $Node.Keys) {
			$value = $Node[$key]
			if ($key -match '^(command|cmd|script|commandLine)$' -and $value -is [string]) {
				Write-Output $value
			}
			else {
				Get-CommandValues -Node $value -Depth ($Depth + 1)
			}
		}
		return
	}

	if ($Node -is [array]) {
		foreach ($item in $Node) { Get-CommandValues -Node $item -Depth ($Depth + 1) }
		return
	}

	foreach ($property in $Node.PSObject.Properties) {
		if ($property.Name -match '^(command|cmd|script|commandLine)$' -and $property.Value -is [string]) {
			Write-Output $property.Value
		}
		else {
			Get-CommandValues -Node $property.Value -Depth ($Depth + 1)
		}
	}
}

function Write-Decision {
	param([string]$Decision, [string]$Reason)

	$result = [ordered]@{
		permissionDecision = $Decision
		permissionDecisionReason = $Reason
	} | ConvertTo-Json -Compress
	[Console]::Out.WriteLine($result)
}

function Get-CurrentBranch {
	param([string]$RepositoryPath)

	try {
		$branch = & git -C $RepositoryPath branch --show-current 2>$null
		if ($LASTEXITCODE -eq 0) { return ([string]$branch).Trim() }
	}
	catch { }
	return ''
}

function Test-LocalMainBranch {
	param([string]$RepositoryPath)

	try {
		$branch = & git -C $RepositoryPath branch --list main 2>$null
		return (-not [string]::IsNullOrWhiteSpace([string]$branch))
	}
	catch { return $false }
}

function Test-MainRefspec {
	param([string]$Refspec, [string]$CurrentBranch, [string]$RepositoryPath)

	$ref = $Refspec.Trim().TrimStart('+')
	if ([string]::IsNullOrWhiteSpace($ref)) { return $false }

	$colon = $ref.IndexOf(':')
	if ($colon -ge 0) {
		$source = $ref.Substring(0, $colon)
		$destination = $ref.Substring($colon + 1)
		if ([string]::IsNullOrWhiteSpace($destination)) { $destination = $source }
	}
	else {
		$destination = $ref
	}

	if ($destination -ieq 'HEAD') { $destination = $CurrentBranch }
	$destination = $destination -replace '^refs/heads/', ''
	if ($destination -ieq 'main') { return $true }

	# A wildcard branch push can include main when that local branch exists.
	if ($destination.Contains('*') -and (Test-LocalMainBranch -RepositoryPath $RepositoryPath)) {
		return $true
	}
	return $false
}

function Test-PushTargetsMain {
	param([string]$PushArguments, [string]$RepositoryPath)

	$tokens = @(
		$PushArguments -split '\s+' |
			Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
			ForEach-Object { $_.Trim([char[]]@([char]34, [char]39)) }
	)
	$positionals = New-Object System.Collections.ArrayList
	$pushAll = $false
	$pushMirror = $false
	$pushPrune = $false

	for ($index = 0; $index -lt $tokens.Count; $index++) {
		$token = $tokens[$index]
		if ($token -in @('--all', '-a')) { $pushAll = $true; continue }
		if ($token -eq '--mirror') { $pushMirror = $true; continue }
		if ($token -in @('--prune', '-p')) { $pushPrune = $true; continue }
		if ($token -in @('--delete', '-d')) { continue }
		if ($token -in @('-o', '--push-option', '--repo', '--receive-pack', '--exec')) {
			$index++
			continue
		}
		if ($token.StartsWith('-')) { continue }
		[void]$positionals.Add($token)
	}

	if ($pushMirror -or $pushPrune) { return $true }
	if ($pushAll -and (Test-LocalMainBranch -RepositoryPath $RepositoryPath)) { return $true }

	$refspecs = @()
	if ($positionals.Count -gt 1 -and -not ([string]$positionals[0]).Contains(':')) {
		$refspecs = @($positionals | Select-Object -Skip 1)
	}
	elseif ($positionals.Count -eq 1 -and ([string]$positionals[0]).Contains(':')) {
		$refspecs = @([string]$positionals[0])
	}

	$currentBranch = Get-CurrentBranch -RepositoryPath $RepositoryPath
	foreach ($refspec in $refspecs) {
		if (Test-MainRefspec -Refspec ([string]$refspec) -CurrentBranch $currentBranch -RepositoryPath $RepositoryPath) {
			return $true
		}
	}

	if ($refspecs.Count -eq 0) {
		if ($currentBranch -ieq 'main') { return $true }
		try {
			$upstream = & git -C $RepositoryPath rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>$null
			if ($LASTEXITCODE -eq 0 -and ([string]$upstream).Trim() -match '(^|/)main$') { return $true }
		}
		catch { }
	}

	return $false
}

try {
	$rawInput = [Console]::In.ReadToEnd()
	if ([string]::IsNullOrWhiteSpace($rawInput)) { exit 0 }
	$event = ConvertFrom-Json -InputObject $rawInput -ErrorAction Stop
}
catch { exit 0 }

$toolName = [string](Get-PropertyValue -Object $event -Names @('toolName', 'tool_name'))
if ($toolName -notmatch '^(?i:Bash|PowerShell|pwsh|shell|terminal)$') { exit 0 }

$repositoryPath = [string](Get-PropertyValue -Object $event -Names @('cwd', 'workingDirectory', 'working_directory'))
if ([string]::IsNullOrWhiteSpace($repositoryPath) -or -not (Test-Path -LiteralPath $repositoryPath -PathType Container)) {
	$repositoryPath = (Get-Location).Path
}

$toolArgs = Get-PropertyValue -Object $event -Names @('toolArgs', 'tool_args', 'toolInput', 'tool_input')
if ($toolArgs -is [string]) {
	try { $toolArgs = ConvertFrom-Json -InputObject $toolArgs -ErrorAction Stop }
	catch { $toolArgs = @{ command = $toolArgs } }
}
$commands = @(Get-CommandValues -Node $toolArgs)
if ($commands.Count -eq 0) { $commands = @(Get-CommandValues -Node $event) }

$denyReason = $null
foreach ($commandText in $commands) {
	if ($toolName -match '^(?i:PowerShell|pwsh|shell|terminal)$') {
		$tokens = $null
		$parseErrors = $null
		$ast = [System.Management.Automation.Language.Parser]::ParseInput([string]$commandText, [ref]$tokens, [ref]$parseErrors)
		$commandAsts = $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.CommandAst] }, $true)
		foreach ($commandAst in $commandAsts) {
			$commandName = [string]$commandAst.GetCommandName()
			if ($commandName -notmatch '(^|[\/])git(?:\.exe)?$') { continue }

			$elements = @($commandAst.CommandElements | ForEach-Object {
				if ($_ -is [System.Management.Automation.Language.StringConstantExpressionAst] -or $_ -is [System.Management.Automation.Language.ExpandableStringExpressionAst]) {
					[string]$_.Value
				}
				else { [string]$_.Extent.Text }
			})
			$pushIndex = -1
			for ($index = 1; $index -lt $elements.Count; $index++) {
				if ($elements[$index] -ieq 'push') { $pushIndex = $index; break }
			}
			if ($pushIndex -lt 0) { continue }

			$pushRepository = $repositoryPath
			for ($index = 1; $index -lt $pushIndex; $index++) {
				if ($elements[$index] -ieq '-C' -and ($index + 1) -lt $pushIndex) {
					$candidate = [string]$elements[$index + 1]
					if (-not [IO.Path]::IsPathRooted($candidate)) { $candidate = Join-Path $repositoryPath $candidate }
					$pushRepository = [IO.Path]::GetFullPath($candidate)
					$index++
				}
			}

			$pushArguments = if (($pushIndex + 1) -lt $elements.Count) { $elements[($pushIndex + 1)..($elements.Count - 1)] -join ' ' } else { '' }
			if (Test-PushTargetsMain -PushArguments $pushArguments -RepositoryPath $pushRepository) {
				$denyReason = 'Blocked git push targeting main. Push the feature branch and open a pull request targeting main instead.'
				break
			}
		}
	}
	else {
		$pattern = '(?im)(?:^|[;|&\r\n])\s*(?:command\s+)?git(?:\.exe)?(?:\s+-C\s+\S+)*\s+push\b(?<args>[^\r\n;|&]*)'
		foreach ($match in [regex]::Matches([string]$commandText, $pattern)) {
			if (Test-PushTargetsMain -PushArguments $match.Groups['args'].Value -RepositoryPath $repositoryPath) {
				$denyReason = 'Blocked git push targeting main. Push the feature branch and open a pull request targeting main instead.'
				break
			}
		}
	}
	if ($denyReason) { break }
}

if ($denyReason) {
	[Console]::Out.WriteLine(([ordered]@{
		permissionDecision = 'deny'
		permissionDecisionReason = $denyReason
	} | ConvertTo-Json -Compress))
}
exit 0
