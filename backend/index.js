const express = require("express")
const app = express()
const db = require("./models")
require("dotenv").config()
const userRouter = require("./routers/usersRouter")

app.use(express.json())
app.use("/", userRouter)

db.sequelize.sync().then(()=>{
    app.listen(process.env.port, () => {
    console.log(`Server listening on port ${process.env.port}`)
    })
}).catch((err)=>{
    console.log(err, "Server is not connecting")
})