const express = require("express")
const router = express.Router()
const {addtoFavorites, removefromFavorites, getAllFavoritesOfUser} = require("../controllers/favoritesController")

router.post("/add", addtoFavorites)
router.delete("/remove", removefromFavorites)
router.get("/get/:userId", getAllFavoritesOfUser)
module.exports = router