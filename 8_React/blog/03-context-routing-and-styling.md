---
title: "React 앱의 뼈대: Context 다크 모드와 React Router"
description: "Props drilling 없이 전역 UI 상태를 공유하고, 중첩 라우트와 URL 파라미터로 여러 화면을 구성한다."
tags: [React, Context, ReactRouter, LocalStorage, CSS]
---

# React 앱의 뼈대: Context 다크 모드와 React Router

작은 컴포넌트 예제는 Props만으로 충분하다. 하지만 다크 모드처럼 여러 위치에서 쓰는 값, 그리고 URL에 따라 바뀌는 화면이 생기면 앱 전체를 연결할 뼈대가 필요하다. 이 글에서는 `Context`와 `React Router`로 그 뼈대를 만든다.

## 1. Context는 공용 UI 상태를 전달하는 통로다

`5_context`의 다크 모드는 `darkMode`와 `toggleDarkMode`를 Context Provider가 제공하고, 필요한 화면에서 `useContext`로 꺼내 쓴다. 중간 컴포넌트를 거치며 Props를 계속 전달하는 props drilling을 피할 수 있다.

```jsx
export const DarkModeContext = createContext();

export function DarkModeProvider({ children }) {
  const [darkMode, setDarkMode] = useState(() =>
    localStorage.getItem("darkMode") === "true"
  );

  const toggleDarkMode = () => setDarkMode((prev) => !prev);

  useEffect(() => {
    localStorage.setItem("darkMode", String(darkMode));
    document.documentElement.classList.toggle("dark", darkMode);
  }, [darkMode]);

  return (
    <DarkModeContext.Provider value={{ darkMode, toggleDarkMode }}>
      {children}
    </DarkModeContext.Provider>
  );
}
```

초기 state를 함수로 전달한 덕분에 localStorage를 첫 렌더링 때만 읽는다. 모드가 바뀌면 effect가 HTML 루트에 `dark` 클래스를 붙이거나 제거하고, 다음 방문을 위해 값을 저장한다.

Context는 테마, 로그인 사용자, 언어처럼 넓게 공유되지만 자주 바뀌지 않는 값에 잘 맞는다. 변경이 매우 잦고 소비자가 많다면 Context 분리나 별도 상태 관리 도구도 검토할 수 있다.

## 2. 중첩 라우트로 공통 레이아웃을 재사용하기

`6_router`는 `createBrowserRouter`로 URL과 화면 컴포넌트를 연결한다. `Root`에 `Navbar`를 두고 `<Outlet />` 위치에 자식 페이지를 표시한다.

```jsx
const router = createBrowserRouter([
  {
    path: "/",
    element: <Root />,
    errorElement: <NotFound />,
    children: [
      { index: true, element: <Home /> },
      { path: "videos", element: <Videos /> },
      { path: "videos/:videoId", element: <VideoDetail /> },
    ],
  },
]);
```

`index: true`는 `/`의 기본 화면이다. `videos/:videoId`의 `:videoId`는 동적인 URL 조각이며, 상세 화면에서는 `useParams()`로 읽는다. 예를 들어 `/videos/react-intro`로 이동하면 `videoId`는 `react-intro`다.

`Link`는 페이지 전체를 새로 요청하는 `<a>` 태그 대신 클라이언트 라우팅을 수행한다. 입력 후 이동해야 할 때는 `useNavigate()`를 사용하면 된다.

## 3. 스타일링도 상황에 맞게 선택하기

라우터 실습에는 세 가지 스타일 접근이 함께 들어 있다.

- 일반 CSS: 전역 스타일 또는 단순한 프로젝트에 적합하다.
- CSS Modules: `Home.module.css`처럼 클래스 이름 충돌을 막는다.
- styled-components: Props에 따라 스타일이 달라지는 컴포넌트를 JavaScript 안에서 선언한다.
- Tailwind CSS: 유틸리티 클래스로 빠르게 레이아웃과 간격을 조합한다.

어느 하나가 절대적으로 낫지는 않다. 팀의 기존 방식, 디자인 시스템 유무, 동적 스타일의 비중을 기준으로 하나를 주력으로 정하고 필요한 경우만 보조적으로 섞는 편이 유지보수에 유리하다.

## 마무리

Context는 앱 전반의 공용 상태를, Router는 URL 기반 화면 전환을 담당한다. 여기에 일관된 스타일 전략까지 정하면, 여러 기능을 담을 수 있는 SPA의 기본 골격이 완성된다.

> 실습 코드: `5_context`, `6_router`
