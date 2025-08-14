const express = require("express")
const router = express.Router()
const {getAllProducts, editProductStock, getProductByType}= require("../controllers/productController")

router.get("/get", getAllProducts)
router.patch("/edit_stock", editProductStock)
router.get("/get/:type", getProductByType)
module.exports = router