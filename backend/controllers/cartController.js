const {Cart} = require("../models/cart")

exports.addtoCart = async (req,res) => {
    try{
        const {userId, productId} = req.body
        const cartItem = new Cart({userId, productId})
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