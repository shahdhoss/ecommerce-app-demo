const mongoose = require("mongoose")
const Schema = mongoose.Schema
const productSchema = new Schema({
    title:{
        type: String,
        required: true
    }, 
    price:{
        type: Number,
        required: true
    }, 
    picture:{
        type: String,
        required: true
    }, 
    rating:{
        type: String, 
        required: true
    },
    stock:{
        type: Number,
        required: true   
    }
}, {timestamps: true})

const Product = mongoose.model("Product", productSchema)
module.exports = {Product}