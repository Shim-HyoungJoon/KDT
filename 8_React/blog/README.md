# React 학습 기록 블로그 연재

이 폴더는 작은 컴포넌트 예제부터 MongoDB를 사용하는 CRUD 애플리케이션까지, React의 핵심 개념을 단계적으로 실습한 기록이다. 아래 글은 각 실습의 **문제 → 구현 방식 → 배운 점**이 자연스럽게 이어지도록 구성한 발행용 Markdown 초안이다.

| 발행 순서 | 글 | 원본 실습 |
| --- | --- | --- |
| 1 | 컴포넌트와 상태로 시작하는 React | `1_react`, `2_array` |
| 2 | 비동기 처리와 복잡한 상태 관리 | `3_hooks`, `4_reducer` |
| 3 | Context와 Router로 앱의 뼈대 만들기 | `5_context`, `6_router` |
| 4 | 로컬 저장소를 이용한 Todo 앱 완성 | `7_todolist` |
| 5 | React · Express · MongoDB CRUD | `8_CRUDProject` |

## 발행 전 공통 점검

- 각 글의 코드 블록은 설명을 위해 간결하게 다듬은 예시다. 실제 저장소의 전체 코드는 링크한 실습 폴더를 기준으로 한다.
- `1_react/src/App.jsx`는 현재 작업 트리에 수정 사항이 있으므로 이 문서에서는 변경하지 않았다.
- 첫 번째 실습의 `users.map((user) => { ... })`처럼 중괄호를 쓴 화살표 함수는 `return`을 명시해야 화면에 목록이 렌더링된다. 글 1의 수정 예시를 사용한다.
- 백엔드 실행에는 `8_CRUDProject/backend/.env`에 `MONGODB_URI`가 필요하다. 민감한 연결 문자열은 글이나 Git 저장소에 올리지 않는다.

각 파일은 Velog, Tistory, GitHub Pages 등의 Markdown 에디터에 그대로 붙여 넣은 뒤, 프로젝트 실행 화면만 추가하면 발행할 수 있다.
