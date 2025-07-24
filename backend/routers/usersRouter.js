const express = require("express")
const router = express.Router()
const {authenticateUser, googleCallback, refresh }= require("../controllers/authenticationController")

router.get("/authenticate", authenticateUser)
router.get("/google/callback", googleCallback)
router.post("/refresh/:id", refresh)
module.exports = router