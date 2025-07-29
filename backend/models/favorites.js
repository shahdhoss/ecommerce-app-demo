const mongoose = require("mongoose")
const Schema = mongoose.Schema
const favoritesSchema = new Schema({
    userId:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
    productId:{
        type: mongoose.Schema.Types.ObjectId,
        ref:"Products",
        required: true
    }
}, {timestamps: true})

const Favorites = mongoose.model("Favorites", favoritesSchema)
module.exports = {Favorites}
