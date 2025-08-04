const {Product} = require("../models/products")

exports.getAllProducts = async(req,res)=>{
    try{
        const products = await Product.find()
        if(!products){
            res.status(500).json({error:"Products are empty"})
        }
        res.status(200).json({products})
    }catch(err){
        console.log("an error happened: ", err)
        res.status(500).json({error:"Failed to get products "})
    }
}

exports.editProductStock = async(req,res)=>{
    try{
        const {productId, stock} = req.body
        const product = await Product.findByIdAndUpdate(productId,{ $set: { stock: stock } },{ new: true })
        if(product){
            res.status(200).json({product})
        }
        res.status(500).json({message: "Product not found"})
    }catch(err){
        console.log(err)
        res.status(500).json({error: "Failed to edit product"})
    }
}