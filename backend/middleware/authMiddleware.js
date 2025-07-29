const jwt = require("jsonwebtoken")

function verifyToken(req,res,next){
    const token = req.header("Authorization")
    if(!token){
        return res.status(401).json({ error: 'Access denied' })
    }
   try{
     const decoded = jwt.verify(token, "shahdDetectiveConan")
        req.userId = decoded.userId
        next()
   }
   catch(err){
    console.log(err)
    res.status(401).json({ error: 'Invalid token' });
   }
}
module.exports = {verifyToken}