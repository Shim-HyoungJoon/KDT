---
title: "React와 Express, MongoDB로 상품 CRUD 만들기"
description: "Vite 프론트엔드와 Express API, Mongoose 모델을 연결해 상품의 생성·조회·수정·삭제를 구현한다."
tags: [React, Express, MongoDB, Mongoose, CRUD, RESTAPI]
---

# React와 Express, MongoDB로 상품 CRUD 만들기

Todo 앱의 데이터는 브라우저에만 남는다. 여러 사용자가 쓰거나 데이터가 사라지면 안 되는 서비스라면 API와 데이터베이스가 필요하다. `8_CRUDProject`는 React 프론트엔드, Express 서버, MongoDB를 연결해 상품을 관리하는 CRUD 애플리케이션을 만든 실습이다.

## 전체 요청 흐름

```text
React 화면
  └─ fetch 요청
       └─ Express /api/products 라우터
            └─ Mongoose Product 모델
                 └─ MongoDB
```

프론트엔드는 기본적으로 `http://127.0.0.1:5000/api/products`에 요청한다. 서버는 JSON 본문을 읽고, Mongoose를 통해 MongoDB에 저장하거나 조회한 결과를 JSON으로 돌려준다.

## 1. Product 모델로 데이터 규칙 정하기

Mongoose schema는 데이터가 어떤 모양이어야 하는지 정의한다.

```js
const productSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    price: { type: Number, required: true, min: 0 },
  },
  { timestamps: true }
);
```

상품명은 필수 문자열이고, 가격은 0 이상인 필수 숫자다. `timestamps: true`를 켜면 `createdAt`, `updatedAt`이 자동으로 생긴다. 프론트엔드 검증만 믿지 않고 서버와 DB 모델에서도 검증해야 잘못된 요청을 막을 수 있다.

## 2. REST API로 CRUD 만들기

`routes/products.js`는 다음 엔드포인트를 제공한다.

| 메서드 | URL | 역할 |
| --- | --- | --- |
| `POST` | `/api/products` | 상품 등록 |
| `GET` | `/api/products` | 상품 목록 조회 |
| `GET` | `/api/products/:id` | 상품 하나 조회 |
| `PUT` | `/api/products/:id` | 상품 수정 |
| `DELETE` | `/api/products/:id` | 상품 삭제 |

수정 API는 ID 형식과 필수 입력값을 먼저 검증하고, `new: true`로 수정된 최신 문서를 돌려준다.

```js
const updatedProduct = await Product.findByIdAndUpdate(
  id,
  { name, price },
  { new: true, runValidators: true }
);
```

`mongoose.isValidObjectId(id)` 검증은 잘못된 형식의 ID가 들어왔을 때 서버 오류 대신 400 응답을 보내게 해 준다. 없는 상품은 404, 잘못된 입력은 400, 예상하지 못한 서버 오류는 500처럼 상황에 맞는 상태 코드를 반환한다.

## 3. Express 서버의 기본 설정

서버는 `express.json()`으로 JSON body를 읽고, 개발 중인 Vite 서버(`http://localhost:5173`)에서의 요청을 CORS로 허용한다. DB 연결 문자열은 `.env`에서 읽는다.

```env
MONGODB_URI=mongodb+srv://<user>:<password>@<cluster>/<database>
PORT=5000
```

`.env`는 반드시 `.gitignore`에 포함한다. 비밀번호나 클라우드 연결 주소를 프론트엔드 코드와 공개 저장소에 넣으면 안 된다.

## 4. React는 서버 상태를 요청하고 화면에 반영한다

화면이 처음 나타날 때 `useEffect`가 목록을 가져온다. 등록과 수정은 폼 하나를 공유하고, `editingId`가 있으면 `PUT`, 없으면 `POST`를 선택한다.

```jsx
const isEditing = editingId !== null;
const response = await fetch(
  isEditing ? `${API_URL}/${editingId}` : API_URL,
  {
    method: isEditing ? "PUT" : "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ name: name.trim(), price: Number(price) }),
  }
);
```

요청 전후로 `loading`과 `error`를 관리하고, 성공하면 `fetchProducts()`를 다시 호출해 서버의 최신 목록을 반영한다. 삭제 전에는 `window.confirm`으로 한 번 더 확인한다. 작은 기능이지만 네트워크 실패와 사용자의 실수를 고려한 기본 UX다.

## 실행 순서

백엔드와 프론트엔드는 터미널을 나누어 실행한다.

```bash
# 1) backend 폴더: .env 작성 후
npm run dev

# 2) frontend 폴더
npm run dev
```

프론트엔드는 Vite 주소(보통 `http://localhost:5173`)를, API 서버는 5000번 포트를 사용한다. CORS의 허용 origin과 실제 프론트엔드 주소가 다르면 브라우저 요청이 차단되므로 함께 확인해야 한다.

## 다음 개선 과제

- 환경별 API 주소를 Vite 환경 변수(`VITE_API_URL`)로 분리하기
- 요청 중복을 줄이기 위해 성공한 생성·수정·삭제 결과로 state를 직접 갱신하기
- 가격 형식과 서버 오류를 더 친절하게 표시하기
- 페이지네이션, 검색, 사용자 인증 추가하기

## 마무리

CRUD는 단순히 네 개의 버튼을 만드는 일이 아니다. 프론트엔드 폼 상태, HTTP 메서드와 상태 코드, 서버 검증, DB 스키마, 오류 처리가 하나의 데이터 흐름으로 만난다. 이 구조를 이해하면 게시글·회원·주문 등 대부분의 서비스 도메인으로 자연스럽게 확장할 수 있다.

> 실습 코드: `8_CRUDProject/frontend`, `8_CRUDProject/backend`
