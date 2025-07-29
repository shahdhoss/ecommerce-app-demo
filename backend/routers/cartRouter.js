const express = require("express")
const router = express.Router()
const { addtoCart, removefromCart} = require("../controllers/cartController")

router.post("/add", addtoCart)
router.delete("/remove", removefromCart)
module.exports = router