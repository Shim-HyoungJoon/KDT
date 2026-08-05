---
title: "React 상태 관리 심화: useEffect, 커스텀 Hook, useReducer"
description: "데이터를 불러오는 시점과 정리 작업을 이해하고, 상태 전환 규칙을 reducer로 분리한다."
tags: [React, useEffect, CustomHook, useReducer, useMemo]
---

# React 상태 관리 심화: useEffect, 커스텀 Hook, useReducer

사용자 입력만 다루는 화면을 넘어서면 서버나 파일에서 데이터를 받아 와야 하고, 상태 변경 규칙도 복잡해진다. `3_hooks`와 `4_reducer`는 이 두 문제를 각각 `useEffect`/커스텀 Hook과 `useReducer`로 풀어낸 실습이다.

## 1. `useEffect`는 렌더링 이후의 작업을 맡는다

상품 목록은 `salesOnly`가 바뀔 때마다 다른 JSON 파일을 요청한다. 네트워크 요청, localStorage 접근, 구독처럼 렌더링 결과 자체가 아닌 작업은 `useEffect` 안에 둔다.

```jsx
useEffect(() => {
  setLoading(true);
  setError(undefined);

  fetch(`data/${salesOnly ? "sale_" : ""}products.json`)
    .then((response) => response.json())
    .then(setProducts)
    .catch(() => setError("데이터를 불러오지 못했습니다."))
    .finally(() => setLoading(false));

  return () => console.log("이전 effect 정리");
}, [salesOnly]);
```

의존성 배열 `[salesOnly]`는 “첫 렌더링 뒤와 `salesOnly`가 바뀐 뒤에만 이 effect를 다시 실행하라”는 뜻이다. 반환하는 함수는 다음 effect가 시작되기 전 또는 컴포넌트가 사라질 때 실행된다. 이 예제에서는 로그를 남기지만, 실제로는 타이머 해제·이벤트 제거·요청 취소 등에 사용한다.

## 2. 반복되는 상태 로직은 커스텀 Hook으로 뺀다

처음에는 상품 요청 로직을 `Products` 컴포넌트에 모두 둘 수 있다. 하지만 같은 패턴이 반복되면 `useProducts`처럼 `use`로 시작하는 함수로 분리한다.

```jsx
function Products() {
  const [checked, setChecked] = useState(false);
  const [loading, error, products] = useProducts({ salesOnly: checked });

  if (loading) return <p>Loading...</p>;
  if (error) return <p>{error}</p>;
  // 화면 렌더링
}
```

이렇게 하면 `Products`는 무엇을 보여 줄지에 집중하고, `useProducts`는 언제 어떤 데이터를 불러올지 책임진다. UI와 데이터 로직을 분리하는 작은 습관이 컴포넌트의 재사용성과 테스트 용이성을 높인다.

## 3. 상태 전환이 많아지면 `useReducer`

멘토를 추가·이름 변경·삭제하는 `4_reducer` 예제는 상태를 여기저기서 조작하지 않는다. 컴포넌트는 “무슨 일이 일어났는지” action을 `dispatch`하고, reducer만 “어떻게 바꿀지” 결정한다.

```jsx
function personReducer(person, action) {
  switch (action.type) {
    case "added":
      return { ...person, mentors: [...person.mentors, action.mentor] };
    case "deleted":
      return {
        ...person,
        mentors: person.mentors.filter((mentor) => mentor.name !== action.name),
      };
    default:
      throw new Error(`Unknown action: ${action.type}`);
  }
}

const [person, dispatch] = useReducer(personReducer, initialPerson);
dispatch({ type: "added", mentor: { name, title } });
```

이 방식은 상태 변경의 종류가 많거나 여러 컴포넌트에서 같은 상태를 갱신할 때 특히 읽기 쉽다. reducer가 새 객체와 새 배열을 반환하므로 불변성도 한곳에서 지킬 수 있다.

## 4. `memo`, `useCallback`, `useMemo`는 측정 후 사용한다

실습의 버튼은 `memo`로 감싸고, 이벤트 핸들러는 `useCallback`, 비용이 큰 계산 결과는 `useMemo`로 메모이제이션한다. 역할은 서로 다르다.

- `memo`: Props가 같다면 자식 컴포넌트 렌더링을 건너뛴다.
- `useCallback`: 함수의 참조를 유지한다.
- `useMemo`: 계산한 **값**을 유지한다.

다만 모든 컴포넌트에 적용할 최적화 도구는 아니다. 의존성을 잘못 관리하면 오히려 코드가 복잡해진다. 렌더링 비용이 실제 병목인지 React DevTools Profiler로 확인한 뒤 적용하는 편이 좋다.

## 마무리

`useEffect`는 외부 세계와 연결하고, 커스텀 Hook은 반복되는 연결 방식을 감추며, reducer는 복잡한 변화 규칙을 한곳에 모은다. 이 세 가지를 조합하면 규모가 커져도 상태 흐름을 따라가기 쉬운 React 코드를 만들 수 있다.

> 실습 코드: `3_hooks`, `4_reducer`
