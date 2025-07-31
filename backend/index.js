const express = require("express")
const app = express()
const {connectMongoDB} = require("./db-connection/mongoose")
const {verifyToken} = require("./middleware/authMiddleware")
require("dotenv").config()
const userRouter = require("./routers/usersRouter")
const favoriteRouter = require("./routers/favoritesRouter")
const cartRouter = require("./routers/cartRouter")
const productRouter = require("./routers/productRouter")

app.use(express.json())
app.use("/", userRouter)
app.use("/favorites", verifyToken ,favoriteRouter)
app.use("/cart", verifyToken, cartRouter )
app.use("/products", productRouter)
connectMongoDB()

app.listen(process.env.port, () => {
    console.log(`Server listening on port ${process.env.port}`)
})


