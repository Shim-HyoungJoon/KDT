import express from "express"
import userRouter from "./routes/user.mjs"
import postRouter from "./routes/practice.mjs"

const app = express()
app.use(express.json())

app.use("/users", userRouter)
app.use("/posts", userRouter)

app.listen(3000, () => {
    console.log("서버 실행 중...")
})