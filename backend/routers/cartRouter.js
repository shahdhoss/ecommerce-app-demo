const express = require("express")
const router = express.Router()
const { addtoCart, removefromCart, getUserCart} = require("../controllers/cartController")

router.post("/add", addtoCart)
router.delete("/remove", removefromCart)
router.get("/get/:userId", getUserCart)
module.exports = router