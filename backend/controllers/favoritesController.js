const {Favorites} = require("../models/favorites")

exports.addtoFavorites = async (req,res) => {
    try{
        const {userId, productId} = req.body
        const favorite = new Favorites({userId, productId})
        await favorite.save()
        res.status(200).json({message: "Product added to favorites"})
    }
    catch(err){
        console.log(err)
        res.status(500).json({error:"Couldn't add product"})
    }
}

exports.removefromFavorites = async(req,res)=>{
    try{
        const {userId, productId} = req.body
        const deletedProduct = await Favorites.findOneAndDelete({userId, productId})
        if (deletedProduct) {
            res.status(200).json({ message: "Favorite removed", data: deletedProduct })
        }
        res.status(404).json({ error: "Favorite not found" })
    }catch(err){
        console.log(err)
        res.status(500).json({error:"Couldn't remove product"})
    }
}