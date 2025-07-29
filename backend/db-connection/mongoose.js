const mongoose = require("mongoose")
const dotenv = require("dotenv")

dotenv.config()

async function connectMongoDB() {
    try{
        await mongoose.connect(process.env.MONGO_URI)
        console.log("connected to food database")
    }catch(err){
        console.log(err)
    }
}
module.exports = {connectMongoDB}