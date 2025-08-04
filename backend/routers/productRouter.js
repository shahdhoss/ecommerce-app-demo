const express = require("express")
const router = express.Router()
const {getAllProducts, editProductStock}= require("../controllers/productController")

router.get("/get", getAllProducts)
router.patch("/edit_stock", editProductStock)
module.exports = router