const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/absences'

//view a summarized list of absences of recent beneficiaries by branch id
router.post(path, (req, res)=>{
    const { id } = req.body
    connection.query("CALL `REDO_MAKMA`.`readGeneralAbsences`(?);"
    ,[id], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                messaage:"There is an error"
            })
        }else{
            res.send( result[0]);
        }
    })
})

//update absence
router.put(path, (req, res)=>{
    const { idReason,idAbsence } = req.body
    connection.query("CALL `REDO_MAKMA`.`updateAbsence`(?,?);"
    ,[idReason,idAbsence], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false
            })
        }else{
            res.json({done:true});
        }
    })
})
module.exports = router;