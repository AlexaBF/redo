const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/attendance'


//create attendance for a beneficiary by their id
router.post(path,(req,res) =>{
    const { id } = req.body
    connection.query("CALL `REDO_MAKMA`.`createAttendance`(?);",[id],(err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false
            })
        }
        else{
            res.json({done:true});
        }
    })
})

module.exports = router;