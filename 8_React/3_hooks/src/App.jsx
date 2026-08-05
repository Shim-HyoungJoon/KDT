import React, { useState } from "react"
// import Products from "../components/products"
import Products from "../components/ProductHook"

function App() {

  const [showProducts, setShowProducts] = useState(true)

  return (
    <>
      <div>
        {showProducts && <Products />}
        <button onClick={() => setShowProducts((show) => !show)}>
          제품 보기
        </button>
      </div>
    </>
  )
}

export default App