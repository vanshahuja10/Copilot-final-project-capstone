const STORAGE_KEY = "todo.tasks.v1";

const taskForm = document.querySelector("#task-form");
const titleInput = document.querySelector("#task-title");
const taskList = document.querySelector("#task-list");
const taskCount = document.querySelector("#task-count");
const emptyState = document.querySelector("#empty-state");

let tasks = loadTasks();

function loadTasks() {
  const savedTasks = localStorage.getItem(STORAGE_KEY);
  return savedTasks === null ? [] : JSON.parse(savedTasks);
}

function saveTasks() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(tasks));
}

function renderTasks() {
  taskList.replaceChildren();

  for (const task of tasks) {
    const row = document.createElement("li");
    row.className = task.completed ? "task-row is-complete" : "task-row";

    const checkbox = document.createElement("input");
    checkbox.className = "task-check";
    checkbox.type = "checkbox";
    checkbox.checked = task.completed;
    checkbox.setAttribute("aria-label", `Mark ${task.title} ${task.completed ? "incomplete" : "complete"}`);
    checkbox.addEventListener("change", () => {
      tasks = tasks.map((currentTask) => currentTask.id === task.id
        ? { ...currentTask, completed: checkbox.checked }
        : currentTask);
      saveTasks();
      renderTasks();
    });

    const title = document.createElement("span");
    title.className = "task-title";
    title.textContent = task.title;

    const deleteButton = document.createElement("button");
    deleteButton.className = "delete-button";
    deleteButton.type = "button";
    deleteButton.textContent = "Delete";
    deleteButton.setAttribute("aria-label", `Delete ${task.title}`);
    deleteButton.addEventListener("click", () => {
      tasks = tasks.filter((currentTask) => currentTask.id !== task.id);
      saveTasks();
      renderTasks();
    });

    row.append(checkbox, title, deleteButton);
    taskList.append(row);
  }

  const count = tasks.length;
  taskCount.textContent = `${count} ${count === 1 ? "task" : "tasks"}`;
  emptyState.hidden = count > 0;
}

taskForm.addEventListener("submit", (event) => {
  event.preventDefault();

  const title = titleInput.value;
  if (title.trim().length === 0) {
    titleInput.setCustomValidity("Enter a title with at least one non-whitespace character.");
    titleInput.reportValidity();
    titleInput.setCustomValidity("");
    return;
  }

  tasks = [...tasks, {
    id: crypto.randomUUID(),
    title,
    completed: false,
  }];

  saveTasks();
  renderTasks();
  taskForm.reset();
  titleInput.focus();
});

renderTasks();