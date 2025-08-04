const {Cart} = require("../models/cart")
const {Product} = require("../models/products")

exports.addtoCart = async (req,res) => {
    try{
        const {userId, productId } = req.body
        const cartItem = await Cart.findOne({userId: userId, productId: productId})
        if (cartItem){
            const updatedCartItem = await Cart.findOneAndUpdate({ userId: userId, productId: productId },{ $inc: { quantity: + 1 } }, {new:true})
            const updatedProductStock = await Product.findOneAndUpdate({ _id: productId, stock: { $gt: 0 } },{ $inc: { stock: -1 } }, { new: true })
            if (!updatedProductStock) {
                return res.status(400).json({ message: "Product out of stock" });
            }
            return res.status(200).json({item: updatedCartItem, productStock: updatedProductStock})
        }
        else{
            const newCartItem = await Cart.create({userId: userId, productId: productId})
            const updatedProductStock = await Product.findOneAndUpdate({ _id: productId, stock: { $gt: 0 } },{ $inc: { stock: -1 } }, { new: true })
            if (!updatedProductStock) {
                return res.status(400).json({ message: "Product out of stock" });
            }
            return res.status(200).json({item: newCartItem, productStock: updatedProductStock})
        }
    }
    catch(err){
        console.log(err)
        return res.status(500).json({error:"Couldn't add product"})
    }
}

exports.removefromCart = async (req,res) => {
    try{
        const {userId, productId } = req.body
        const cartItem = await Cart.findOne({userId: userId, productId: productId})
        if (cartItem){
                const updatedCartItem = await Cart.findOneAndUpdate({ userId: userId, productId: productId , quantity: { $gt: 0 } } ,{ $inc: { quantity: - 1 } }, {new:true})
                if (!updatedCartItem) {
                    return res.status(400).json({ message: "Product removed from cart" });
                }
                const updatedProductStock = await Product.findOneAndUpdate({ _id: productId} ,{ $inc: { stock: + 1 } }, { new: true })
                return res.status(200).json({item: updatedCartItem, productStock: updatedProductStock})
        }
        else{
            return res.status(400).json({ message: "Product not in cart" });
        }
    }
    catch(err){
        console.log(err)
        return res.status(500).json({error:"Couldn't delete product"})
    }
}
