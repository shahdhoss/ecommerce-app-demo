require("dotenv").config()
const jwt = require("jsonwebtoken")
const {User} = require("../models")

const generateJWTTokens = (user) => {
    const tokens = {}
    tokens["access_token"] = jwt.sign({id: user.id }, process.env.ACCESS_TOKEN_SECRET, {
        expiresIn: process.env.ACCESS_TOKEN_LIFETIME
    })
    tokens["refresh_token"] = jwt.sign({id: user.id }, process.env.REFRESH_TOKEN_SECRET, {
        expiresIn: process.env.REFRESH_TOKEN_LIFETIME
    })
    return tokens
}

exports.authenticateUser = async (req,res) =>{
    const GOOGLE_OAUTH_URL = process.env.GOOGLE_OAUTH_URL;
    const GOOGLE_CLIENT_ID = process.env.GOOGLE_CLIENT_ID;
    const GOOGLE_CALLBACK_URL = "http://localhost:8000/google/callback";
    const GOOGLE_OAUTH_SCOPES = ["https://www.googleapis.com/auth/userinfo.email","https://www.googleapis.com/auth/userinfo.profile"];
    try{
        const state = "some_state";
        const scope = encodeURIComponent(GOOGLE_OAUTH_SCOPES.join(" "));
        const redirectUri = encodeURIComponent(GOOGLE_CALLBACK_URL);
        const GOOGLE_OAUTH_CONSENT_SCREEN_URL = `${GOOGLE_OAUTH_URL}?client_id=${GOOGLE_CLIENT_ID}&redirect_uri=${redirectUri}&access_type=offline&response_type=code&state=${state}&scope=${scope}`
        console.log(GOOGLE_OAUTH_CONSENT_SCREEN_URL)
        res.redirect(GOOGLE_OAUTH_CONSENT_SCREEN_URL);
    }catch(err){
        console.log(err)
    }
}

exports.googleCallback = async(req,res)=>{
    try{
        const {code} = req.query
        const data={
            code,
            client_id: process.env.GOOGLE_CLIENT_ID,
            client_secret: process.env.GOOGLE_CLIENT_SECRET,
            redirect_uri:  "http://localhost:8000/google/callback",
            grant_type: "authorization_code"
        }
        const response = await fetch(process.env.GOOGLE_ACCESS_TOKEN_URL,{
            method: "POST",
            body: JSON.stringify(data)
        })
        const access_token_data = await response.json()
        const {id_token}= access_token_data
        const token_info_response = await fetch(
            `${process.env.GOOGLE_TOKEN_INFO_URL}?id_token=${id_token}`
        )
        const token_info_data = await token_info_response.json()
        const {email,name} = token_info_data
        let user = await users.findOne({where:{email:email}})
        if(!user){
            user = await users.create({email: email, name: name})
        }
        const {access_token, refresh_token} = generateJWTTokens(user)
        user.refresh_token = refresh_token
        await user.save()
        res.status(token_info_response.status).json({user, access_token})  
    } catch(err){
        console.log(err)
    }
}

exports.refresh = async(req,res)=>{
    try{
        const {id} = req.params
        const user = await users.findOne({where: {id:id}})
        if(!user){
            return res.status(404).json({message: "User not found"})
        }
        const refresh_token = user.refresh_token
        if(refresh_token){
            jwt.verify(refresh_token, process.env.REFRESH_TOKEN_SECRET, (err, decoded)=>{
                if(err){
                    return res.status(406).json({message: "Unauthorized"})
                }
                const access_token = jwt.sign({
                    id: user.id,
                }, process.env.ACCESS_TOKEN_LIFETIME, {
                    expiresIn: '10m'
                })
                return res.json(access_token)
            })
        }else{
            return res.status(406).json({message:"Unauthorized"})
        }
    }catch(err){
        console.log(err)
    }
}