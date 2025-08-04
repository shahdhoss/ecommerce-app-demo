const mongoose = require("mongoose")
const Schema = mongoose.Schema
const cartSchema = new Schema({
    userId:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
    productId:{
        type: mongoose.Schema.Types.ObjectId,
        ref:"Products",
        required: true
    }, 
    quantity:{
        type: Number,
        required: true
    }
}, {timestamps: true})

const Cart = mongoose.model("Cart", cartSchema)
module.exports = {Cart}