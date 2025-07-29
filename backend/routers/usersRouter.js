const express = require("express")
const router = express.Router()
// const {authenticateUser, googleCallback, refresh }= require("../controllers/OAUTHauthenticationController")
const {registerUser, loginUser} = require("../controllers/authenticationController")

// router.get("/authenticate", authenticateUser)
// router.get("/google/callback", googleCallback)
// router.post("/refresh/:id", refresh)
router.post("/register", registerUser)
router.post("/login", loginUser)
module.exports = router