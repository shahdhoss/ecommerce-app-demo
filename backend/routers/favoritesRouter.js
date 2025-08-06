const express = require("express")
const router = express.Router()
const {addtoFavorites, removefromFavorites, getFavoritesDetails} = require("../controllers/favoritesController")

router.post("/add", addtoFavorites)
router.delete("/remove", removefromFavorites)
router.get("/get/:userId", getFavoritesDetails)
module.exports = router