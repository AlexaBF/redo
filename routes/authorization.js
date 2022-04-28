const jwt = require('jsonwebtoken');
const {key} =require('../config/jwt.js')

module.exports.authMiddleware = ((req,res,next)=>{
    const token= req.headers["authorization"];
    if(token){
        jwt.verify(token, key, (err,decoded)=>{
            if (err){
                return res.status(401).send({
                    done: false,
                    message: 'Invalid token'
                })
            }
            req.decoded= decoded
            next()
        });
    }
    res.status(401).send({done: false, message: "Token no proporcionado"})
})
module.exports.login = (req,res)=>{
   const {mail, password} = req.body
    //TODO: CALL SOME PROCEDURE HERE
    if(mail == 'mawi@tec.mx', password =='123'){
        const payload = {
            rol: '1', //The rol of the user
            branch: '2', //The branch of the rol
            id: '2', //The id of the user
        }
        const token = jwt.sign(payload, key, {expiresIn:7200 }); //TODO: CHECK FOR EXPIRATION TIME
        res.status(200).send({
            done: true,
            token,
        })
    }
    res.status(400).send({
        done: false,
        message: "User or password not found"
    })
}
