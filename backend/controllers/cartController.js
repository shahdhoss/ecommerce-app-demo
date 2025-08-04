const {Cart} = require("../models/cart")
const {Product} = require("../models/products")

exports.addtoCart = async (req,res) => {
    try{
        const {userId, productId, quantity} = req.body
        const cartItem = new Cart({userId, productId, quantity})
        await cartItem.save()
        res.status(200).json({message: "Product added to cart"})
    }
    catch(err){
        console.log(err)
        res.status(500).json({error:"Couldn't add product"})
    }
}

exports.removefromCart = async(req,res)=>{
    try{
        const {userId, productId} = req.body
        const deletedProduct = await Cart.findOneAndDelete({userId, productId})
        if (deletedProduct) {
            res.status(200).json({ message: "Cart item removed", data: deletedProduct })
        }
        res.status(404).json({ error: "Item not found" })
    }catch(err){
        console.log(err)
        res.status(500).json({error:"Couldn't remove product"})
    }
}

exports.incrementItem = async (req,res) =>{
    try{
        const {userId, productId} = req.body
        const product = Product.find({_id: productId})
        const cartItem = Cart.find({userId, productId})
        if(product["stock"]>0){
            cartItem["quantity"]++
            res.status(200).json({cartItem: cartItem })
        } 
        res.status(500).json({error: "Item not in stock"})
    }catch(err){
        console.log("An error happened: ", err)
        res.status(500).json({error: "Something went wrong"})
    }
}