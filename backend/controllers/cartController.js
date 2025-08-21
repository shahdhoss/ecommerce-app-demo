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
            const userCart = await Cart.find({userId:userId})
            const productDetails = await Promise.all(
            userCart.map(item => Product.findOne({ _id: item.productId }))
            );
            const cartWithDetails = productDetails.map((product, index) => ({
            ...product.toObject(),            
            quantity: userCart[index].quantity,   
            }));
            return res.status(200).json({item: updatedCartItem, productStock: updatedProductStock, userCart: cartWithDetails})
        }
        else{
            const newCartItem = await Cart.create({userId: userId, productId: productId})
            const updatedProductStock = await Product.findOneAndUpdate({ _id: productId, stock: { $gt: 0 } },{ $inc: { stock: -1 } }, { new: true })
            if (!updatedProductStock) {
                return res.status(400).json({ message: "Product out of stock" });
            }
            const userCart = await Cart.find({userId:userId})
            const productDetails = await Promise.all(
            userCart.map(item => Product.findOne({ _id: item.productId }))
            );
            const cartWithDetails = productDetails.map((product, index) => ({
            ...product.toObject(),            
            quantity: userCart[index].quantity,   
            }));
            return res.status(200).json({item: newCartItem, productStock: updatedProductStock, userCart: cartWithDetails})
        }
    }
    catch(err){
        console.log(err)
        return res.status(500).json({error:"Couldn't add product"})
    }
}

exports.removefromCart = async (req, res) => {
    try {
        const { userId, productId } = req.body;
        const cartItem = await Cart.findOne({ userId, productId });
        if (!cartItem) {
        return res.status(400).json({ message: "Product not in cart" });
        }
        if (cartItem.quantity <= 0) {
        return res.status(400).json({ message: "Product already at quantity 0" });
        }
        const updatedCartItem = await Cart.findOneAndUpdate({ userId, productId },{ $inc: { quantity: -1 } },{ new: true });
        const updatedProductStock = await Product.findOneAndUpdate({ _id: productId },{ $inc: { stock: 1 } },{ new: true });

        if (updatedCartItem.quantity === 0) {
        await Cart.deleteOne({ _id: updatedCartItem._id });
        }

        const userCart = await Cart.find({ userId });
        const productDetails = await Promise.all(
        userCart.map(item => Product.findOne({ _id: item.productId }))
        );

        const cartWithDetails = productDetails.map((product, index) => ({
            ...product.toObject(),
            quantity: userCart[index].quantity,
        }));

        return res.status(200).json({item: updatedCartItem,productStock: updatedProductStock,userCart: cartWithDetails,});
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: "Couldn't delete product" });
    }
};


exports.getUserCart= async(req,res)=>{
    try{
        const  {userId} = req.params
        const cart = await Cart.find({userId:userId})
        const productDetails = await Promise.all(
            cart.map(item => Product.findOne({ _id: item.productId }))
            );
        const cartWithDetails = productDetails.map((product, index) => ({
        ...product.toObject(),            
        quantity: cart[index].quantity,   
        }));
        return res.status(200).json({cart:cartWithDetails})
    }catch(err){
        console.log(err)
        return res.status(500).json({error: "Couldn't get favorites"})
    }
}

exports.removeItemfromCartCompletely = async (req, res) => {
    try {
        const { userId, productId } = req.body;
        const item = await Cart.findOne({ userId: userId, productId: productId });
        if (item) {
            await Product.findOneAndUpdate({ _id: productId },{ $inc: { stock: item.quantity } },{ new: true });
            await Cart.deleteOne({ _id: item._id });
            const userCart = await Cart.find({userId:userId})
            const productDetails = await Promise.all(
            userCart.map(item => Product.findOne({ _id: item.productId }))
            );
            const cartWithDetails = productDetails.map((product, index) => ({
            ...product.toObject(),            
            quantity: userCart[index].quantity,   
            }));
            return res.status(200).json({ message: "Item removed", item: item , userCart: cartWithDetails});
        }
        return res.status(404).json({ message: "Item not found" });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: "Something went wrong" });
    }
}
exports.getUserCartTotal= async(req,res)=>{
    try{
        var cartTotal = 0
        const  {userId} = req.params
        const cart = await Cart.find({userId:userId})
        const productDetails = await Promise.all(
            cart.map(item => Product.findOne({ _id: item.productId }))
            );
        const cartWithDetails = productDetails.map((product, index) => ({
        ...product.toObject(),            
        quantity: cart[index].quantity,   
        }));
        for (var i=0;i<cartWithDetails.length;i++){
            cartTotal+=cartWithDetails[i].quantity*cartWithDetails[i].price
        }
        return res.status(200).json({cartTotal:cartTotal})
    }catch(err){
        console.log(err)
        return res.status(500).json({error: "Couldn't get favorites"})
    }
}