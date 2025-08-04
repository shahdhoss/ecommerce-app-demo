const {Favorites} = require("../models/favorites")
const {Product}= require("../models/products")

exports.addtoFavorites = async (req,res) => {
    try{
        const {userId, productId} = req.body
        const existingFavorite = await Favorites.findOne({ userId, productId });
        if (existingFavorite) {
            return res.status(400).json({ message: "Product already in favorites" });
        }
        const favorite = new Favorites({userId, productId})
        await favorite.save()
        return res.status(200).json({message: "Product added to favorites"})
    }
    catch(err){
        console.log(err)
        return res.status(500).json({error:"Couldn't add product"})
    }
}

exports.removefromFavorites = async(req,res)=>{
    try{
        const {userId, productId} = req.body
        
        const deletedProduct = await Favorites.findOneAndDelete({userId, productId})
        if (deletedProduct) {
           return res.status(200).json({ message: "Favorite removed", data: deletedProduct })
        }
        return res.status(404).json({ error: "Favorite not found" })
    }catch(err){
        console.log(err)
        return res.status(500).json({error:"Couldn't remove product"})
    }
}

exports.getAllFavoritesOfUser = async(req,res)=>{
    try{
        const  {userId} = req.params
        const products = await Favorites.find({userId:userId})
        return res.status(200).json({ products })

    }catch(err){
        console.log("an error happened: ", err)
        return res.status(500).json({error: "Couldn't get favorites"})
    }
}

exports.getFavoritesDetails= async(req,res)=>{
    try{
        const  {userId} = req.params
        const favorites = await Favorites.find({userId:userId})
         const productDetails = await Promise.all(
            favorites.map(fav => Product.findOne({ _id: fav.productId }))
            );
        return res.status(200).json({productDetails})
    }catch(err){
        console.log(err)
        return res.status(500).json({error: "Couldn't get favorites"})
    }
}