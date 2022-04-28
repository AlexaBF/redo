const jwt = require('jsonwebtoken');
const {key} =require('../config/jwt.js')
const {connection} = require("../config/mysql.js")

//Middleware that checks the and validates de token
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
    return res.status(401).send({done: false, message: "Token no proporcionado"})
})
//The endpoint that validates the credentials and  returns the token
module.exports.login = (req,res)=>{
   const {mail, password} = req.body
    //TODO: CALL SOME PROCEDURE HERE
    connection.query("CALL `REDO_MAKMA`.`loginUser`(?,?);"
        ,[mail,password], (err, result, fields) =>{
            if(err){
                res.status(500).json({
                    done:false,
                    message:"Error with the db"
                })
                return;
            }
            const {cant, id, role, branch} = result[0][0];
            if(cant>0){
                const payload = {
                    id,
                    rol : role,
                    branch
                }
                const token = jwt.sign(payload, key, {expiresIn:7200 }); //TODO: CHECK FOR EXPIRATION TIME
                res.status(200).send({
                    done: true,
                    token,
                })
            }else{
                res.status(400).send({
                    done: false,
                    message: "User or password not found"
                })
            }
        })
}
