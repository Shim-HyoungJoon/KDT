---
title: "작지만 완결된 React 프로젝트: 다크 모드 Todo 앱"
description: "컴포넌트 분리, 필터링, localStorage 영속성, UUID를 하나의 Todo 앱으로 연결한다."
tags: [React, TodoApp, LocalStorage, Context, UUID]
---

# 작지만 완결된 React 프로젝트: 다크 모드 Todo 앱

개념을 따로 익힌 다음에는 한 화면 안에서 연결해 보는 과정이 필요하다. `7_todolist`는 할 일 추가·완료·삭제·필터링, 다크 모드, 새로고침 후 데이터 유지까지 담은 작은 완성 프로젝트다.

## 컴포넌트의 역할을 나누기

앱은 다음처럼 구성되어 있다.

```text
App
├─ DarkModeProvider
├─ Header       : 테마 전환, 전체/진행/완료 필터 선택
└─ TodoList
   ├─ Todo      : 한 항목의 완료 상태 변경과 삭제
   └─ AddTodo   : 새 항목 입력과 추가
```

`App`은 현재 필터만 관리한다. 목록 데이터와 저장은 `TodoList`, 테마는 `DarkModeProvider`, 개별 할 일의 표시와 이벤트는 `Todo`가 맡는다. 컴포넌트마다 책임이 좁아져서 기능을 고치거나 테스트하기 편해진다.

## 1. Todo 데이터의 형태를 먼저 정한다

각 항목은 아래처럼 ID, 내용, 상태를 가진다.

```js
{ id: "uuid", text: "React 복습하기", status: "active" }
```

`AddTodo`는 `uuid` 라이브러리로 중복 가능성이 매우 낮은 ID를 만들고, 빈 문자열은 `trim()`으로 막는다.

```jsx
function handleSubmit(event) {
  event.preventDefault();
  if (text.trim().length === 0) return;

  onAdd({ id: uuidv4(), text, status: "active" });
  setText("");
}
```

배열 변경은 기존 값을 직접 수정하지 않는다. 추가는 전개 연산자, 수정은 `map`, 삭제는 `filter`로 처리한다.

```jsx
const handleUpdate = (updated) =>
  setTodos(todos.map((todo) => (todo.id === updated.id ? updated : todo)));

const handleDelete = (deleted) =>
  setTodos(todos.filter((todo) => todo.id !== deleted.id));
```

## 2. 필터는 데이터를 복사하지 않고 계산한다

현재 탭에 맞는 목록은 별도 state로 저장하지 않고 원본 `todos`와 `filter`에서 계산한다. 같은 정보를 여러 state에 보관하면 둘이 어긋날 위험이 있기 때문이다.

```js
function getFilteredItems(todos, filter) {
  if (filter === "all") return todos;
  return todos.filter((todo) => todo.status === filter);
}
```

완료 체크박스를 누르면 status만 `active`와 `completed` 사이에서 바뀌고, `Header`에서 선택한 `all`, `active`, `completed` 필터가 바로 반영된다.

## 3. localStorage로 새로고침 뒤에도 유지하기

초기 state를 만드는 함수에서 localStorage를 한 번 읽고, `todos`가 바뀔 때마다 effect로 저장한다.

```jsx
const [todos, setTodos] = useState(() => {
  const saved = localStorage.getItem("todos");
  return saved ? JSON.parse(saved) : [];
});

useEffect(() => {
  localStorage.setItem("todos", JSON.stringify(todos));
}, [todos]);
```

localStorage는 브라우저에 문자열만 저장하므로 `JSON.stringify`와 `JSON.parse`가 필요하다. 이 방식은 서버 없이도 개인 설정이나 작은 데이터에 편리하지만, 기기 간 동기화나 민감한 정보 저장에는 적합하지 않다.

## 4. 테마는 Context에서 독립적으로 관리한다

Header의 달 아이콘과 해 아이콘은 `useDarkMode()`로 Context 값을 가져온다. 테마는 Todo의 Props로 전달할 필요가 없으므로, 기능 컴포넌트가 불필요하게 테마를 알지 않아도 된다. 첫 진입 시에는 저장된 값이 없을 경우 운영체제의 `prefers-color-scheme`도 확인한다는 점이 좋다.

## 마무리

Todo 앱은 작지만 실제 프론트엔드의 핵심 흐름을 모두 연습한다. 데이터를 설계하고, 상태를 한 곳에 두고, 필요한 컴포넌트에만 이벤트를 전달하고, 브라우저 저장소와 동기화한다. 다음 단계는 이 데이터를 브라우저가 아니라 API와 데이터베이스에 저장하는 일이다.

> 실습 코드: `7_todolist`
