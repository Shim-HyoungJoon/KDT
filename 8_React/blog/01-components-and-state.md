---
title: "React 입문: 컴포넌트와 상태로 사용자 목록 만들기"
description: "Vite로 만든 React 프로젝트에서 Props, 조건부 렌더링, 제어 컴포넌트, 배열 상태를 차례로 익혀 본다."
tags: [React, Vite, useState, useRef]
---

# React 입문: 컴포넌트와 상태로 사용자 목록 만들기

React를 처음 배울 때 가장 중요한 전환점은 “HTML을 JavaScript로 조작한다”에서 “상태에 따라 UI를 선언한다”로 사고방식을 바꾸는 일이다. 이번 실습은 프로필을 보여 주는 작은 컴포넌트에서 출발해, 사용자를 추가·선택·삭제할 수 있는 목록으로 발전한다.

## 1. UI를 재사용 가능한 조각으로 나누기

`1_react`에서는 `Avatar`와 `Profile`을 분리했다. `Profile`은 이름과 직함을 표시하고, 이미지와 `isNew` 값은 다시 `Avatar`로 넘긴다. 부모가 데이터를 전달하고 자식은 화면을 그리는 구조다.

```jsx
function Avatar({ image, isNew }) {
  return (
    <div className="avatar">
      <img className="photo" src={image} alt="프로필 사진" />
      {isNew && <span className="new">New</span>}
    </div>
  );
}

function Profile({ image, name, title, isNew }) {
  return (
    <div className="profile">
      <Avatar image={image} isNew={isNew} />
      <h2>{name}</h2>
      <p>{title}</p>
    </div>
  );
}
```

여기서 `image`, `name`, `title`처럼 컴포넌트 밖에서 전달받는 값이 Props다. `{isNew && ...}`는 조건이 참일 때만 배지를 렌더링하는 가장 간단한 조건부 렌더링이다. 같은 모양의 프로필을 여러 개 만들 때 마크업을 복사하지 않아도 되므로, 화면의 변화에 더 강한 구조가 된다.

## 2. 입력값은 state 하나의 원본으로 관리하기

로그인 입력창 예제는 `useState`로 `userid`, `password`를 관리한다. input의 `value`를 state에 연결하고 `onChange`에서 state를 바꾸는 방식을 **제어 컴포넌트**라고 한다.

```jsx
const [inputs, setInputs] = useState({ userid: "", password: "" });

function onChange(event) {
  const { name, value } = event.target;
  setInputs({ ...inputs, [name]: value });
}
```

`...inputs`는 기존 필드를 복사하고, `[name]`에는 방금 입력된 필드만 덮어쓴다. React state는 기존 객체를 직접 수정하는 대신 새 객체를 만들어 전달해야 변경을 확실하게 감지한다. 초기화 버튼도 같은 원칙으로 빈 객체를 새로 넣으면 된다.

## 3. 배열 상태에는 `map`, `filter`, 전개 연산자

`2_array`의 사용자 목록은 CRUD 중 Create, Delete, Update의 기본 형태를 담고 있다.

```jsx
// 추가
setUsers([...users, newUser]);

// 삭제
setUsers(users.filter((user) => user.id !== id));

// 선택 상태 토글
setUsers(users.map((user) =>
  user.id === id ? { ...user, select: !user.select } : user
));
```

세 줄 모두 원본 배열과 객체를 바꾸지 않고 새 값을 만든다는 점이 핵심이다. 목록을 그릴 때는 `map`과 안정적인 `key`를 함께 사용한다.

```jsx
{users.map((user) => (
  <User key={user.id} user={user} />
))}
```

실습 중 흔히 하는 실수도 있다. 아래처럼 중괄호를 사용하면 반환문이 필요하다.

```jsx
// 렌더링되지 않음: 반환값이 undefined
users.map((user) => { <User user={user} /> });

// 올바른 두 가지 방식
users.map((user) => (<User key={user.id} user={user} />));
users.map((user) => { return <User key={user.id} user={user} />; });
```

## 4. `useRef`는 화면과 무관한 값을 보관할 때

새 사용자의 ID는 `useRef(5)`로 관리한다. ref의 `current`를 바꿔도 렌더링이 다시 일어나지 않는다. 따라서 화면에 표시할 값에는 `useState`, 다음 ID처럼 렌더링 자체가 필요 없는 값에는 `useRef`가 어울린다.

## 마무리

이 단계에서 기억할 문장은 하나다. **UI는 state의 결과이고, state는 직접 고치지 않고 교체한다.** 다음 글에서는 이 원칙을 비동기 데이터 요청과 더 복잡한 상태 전환으로 확장해 보겠다.

> 실습 코드: `1_react`, `2_array`
