const express = require("express")
const router = express.Router()
const { addtoCart, removefromCart, getUserCart, removeItemfromCartCompletely} = require("../controllers/cartController")

router.post("/add", addtoCart)
router.delete("/remove", removefromCart)
router.get("/get/:userId", getUserCart)
router.delete("/remove_completely", removeItemfromCartCompletely)
module.exports = router