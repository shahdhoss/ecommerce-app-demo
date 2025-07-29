const express = require("express")
const router = express.Router()
const {addtoFavorites, removefromFavorites} = require("../controllers/favoritesController")

router.post("/add", addtoFavorites)
router.delete("/remove", removefromFavorites)
module.exports = router