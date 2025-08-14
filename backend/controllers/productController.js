const {Product} = require("../models/products")

exports.getAllProducts = async(req,res)=>{
    try{
        const products = await Product.find()
        if(!products){
            return res.status(500).json({error:"Products are empty"})
        }
        return res.status(200).json({products})
    }catch(err){
        console.log("an error happened: ", err)
        return res.status(500).json({error:"Failed to get products "})
    }
}

exports.editProductStock = async(req,res)=>{
    try{
        const {productId, stock} = req.body
        const product = await Product.findByIdAndUpdate(productId,{ $set: { stock: stock } },{ new: true })
        if(product){
            return res.status(200).json({product})
        }
        return res.status(500).json({message: "Product not found"})
    }catch(err){
        console.log(err)
        return res.status(500).json({error: "Failed to edit product"})
    }
}
exports.getProductByType = async(req,res)=>{
    try{
        const {type} = req.params
        const products = await Product.find({type: type})
        if(products){
            return res.status(200).json({products})
        }
    return res.status(500).json({message: "Product type not found"})

    }catch(err){
        console.log("An error occurred: ", err)
    return res.status(500).json({message: "Something went wrong"})
    }
}