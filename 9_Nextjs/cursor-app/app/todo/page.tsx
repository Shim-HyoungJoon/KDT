"use client";

import { useEffect, useState } from "react";
import TodoList from "@/components/TodoList";
import type { Todo } from "@/types/todo";
import { TODO_STORAGE_KEY } from "@/types/todo";

function loadTodosFromStorage(): Todo[] {
  if (typeof window === "undefined") {
    return [];
  }

  const stored = localStorage.getItem(TODO_STORAGE_KEY);
  if (!stored) {
    return [];
  }

  try {
    const parsed: unknown = JSON.parse(stored);
    if (!Array.isArray(parsed)) {
      return [];
    }

    return parsed.filter(
      (item): item is Todo =>
        typeof item === "object" &&
        item !== null &&
        "id" in item &&
        typeof item.id === "string" &&
        "text" in item &&
        typeof item.text === "string" &&
        "completed" in item &&
        typeof item.completed === "boolean",
    );
  } catch {
    return [];
  }
}

export default function TodoPage() {
  const [todos, setTodos] = useState<Todo[]>([]);
  const [inputValue, setInputValue] = useState("");
  const [isLoaded, setIsLoaded] = useState(false);

  useEffect(() => {
    setTodos(loadTodosFromStorage());
    setIsLoaded(true);
  }, []);

  useEffect(() => {
    if (!isLoaded) {
      return;
    }
    localStorage.setItem(TODO_STORAGE_KEY, JSON.stringify(todos));
  }, [todos, isLoaded]);

  const handleAdd = () => {
    const text = inputValue.trim();
    if (!text) {
      return;
    }

    const newTodo: Todo = {
      id: crypto.randomUUID(),
      text,
      completed: false,
    };

    setTodos((prev) => [...prev, newTodo]);
    setInputValue("");
  };

  const handleToggle = (id: string) => {
    setTodos((prev) =>
      prev.map((todo) =>
        todo.id === id ? { ...todo, completed: !todo.completed } : todo,
      ),
    );
  };

  const handleDelete = (id: string) => {
    setTodos((prev) => prev.filter((todo) => todo.id !== id));
  };

  if (!isLoaded) {
    return (
      <div className="flex min-h-full flex-1 items-center justify-center bg-zinc-50 dark:bg-black">
        <p className="text-sm text-zinc-500 dark:text-zinc-400">Loading...</p>
      </div>
    );
  }

  return (
    <div className="flex min-h-full flex-1 flex-col items-center bg-zinc-50 px-4 py-16 dark:bg-black">
      <main className="flex w-full max-w-lg flex-col items-center gap-8">
        <div className="text-center">
          <h1 className="text-3xl font-semibold tracking-tight text-zinc-900 dark:text-zinc-50">
            Todo App
          </h1>
          <p className="mt-2 text-sm text-zinc-500 dark:text-zinc-400">
            Your tasks are saved in local storage.
          </p>
        </div>

        <TodoList
          todos={todos}
          inputValue={inputValue}
          onInputChange={setInputValue}
          onAdd={handleAdd}
          onToggle={handleToggle}
          onDelete={handleDelete}
        />
      </main>
    </div>
  );
}
