export interface Todo {
  id: string;
  text: string;
  completed: boolean;
}

export const TODO_STORAGE_KEY = "todos";
