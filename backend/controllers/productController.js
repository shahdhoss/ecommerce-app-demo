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