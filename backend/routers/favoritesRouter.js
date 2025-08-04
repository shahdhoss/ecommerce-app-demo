const express = require("express")
const router = express.Router()
const {addtoFavorites, removefromFavorites, getAllFavoritesOfUser, getFavoritesDetails} = require("../controllers/favoritesController")

router.post("/add", addtoFavorites)
router.delete("/remove", removefromFavorites)
router.get("/get/:userId", getAllFavoritesOfUser)
router.get("/get/details/:userId", getFavoritesDetails)
module.exports = router