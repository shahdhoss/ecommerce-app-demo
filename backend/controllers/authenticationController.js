const {User} = require("../models/users")
const bcrypt = require("bcrypt")
const jwt = require("jsonwebtoken")

exports.registerUser = async (req,res)=>{
    try{
        const {name, email, password} = req.body
        const hashedPassword = await bcrypt.hash(password, 10)
        const user = new User({name, email, password: hashedPassword})
        await user.save()
        const token = jwt.sign({userId:user._id}, "shahdDetectiveConan", {
            expiresIn: "1d"
        })
        res.status(200).json({token})
    }catch (err){
        console.log(err)
        res.status(500).json({error:"Failed to register user"})
    }
}

exports.loginUser = async (req,res)=>{
    try{
        const {email, password} = req.body
        const user = await User.findOne({email: email})
        if(!user){
            return res.status(500).json({error: "User does not exist"})
        }
        const isPasswordMatch = bcrypt.compare(password, user.password)
        if(!isPasswordMatch){
            return res.status(401).json({error :"Password is incorrect"})
        }
        const token = jwt.sign({userId:user._id}, "shahdDetectiveConan", {
            expiresIn: "1d"
        })
        res.status(200).json({token})
    }catch(err){
        console.log(err)
        res.status(500).json({error:"Login failed"})

    }
}


