const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/frecuency'

//gets the attendance frequency catalog (monthly,biweekly,weekly)
router.get(path, (req,res) =>{
    connection.query("CALL `REDO_MAKMA`.`readFrecuencies`();", [], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                message:"There is an error"
            })
        }else{
            res.send(result[0]);
        }
    })
})


module.exports = router;

