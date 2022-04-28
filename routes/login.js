const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const {validateUser} = require("../lib/validations.js")
const path = '/login'

//
router.post(path, (req, res) =>{
    const {mail,password} = req.body
    

    //Juan@juan.com 1234
    connection.query("SELECT COUNT(*) as existe FROM `Usuario` WHERE correo= ? AND password=sha2(?,224)",
    [mail,password],
    (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false
            })
        }

        if(result[0].existe ==1){
            res.json({ done: true ,message:result[0],mail,password});
            
        }else{
            res.json({
                done: false,
                message:"Autenticación incorrecta"
            })
        }
        
            
    })
})



    

    

    

module.exports = router;