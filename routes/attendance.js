const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/attendance'


//create attendance for a beneficiary by their id
router.post(path,(req,res) =>{
    const { folio,attendance } = req.body
    connection.query("CALL `REDO_MAKMA`.`attendance`(?, ?);",[folio,attendance],(err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false
            })
        }
        else{
            res.send(result[0]);
        }
    })
})

module.exports = router;