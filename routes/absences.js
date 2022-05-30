const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/absences'

//view a summarized list of absences of recent beneficiaries by branch id
router.get(path, (req, res)=>{
    const { IdBranch } = req.token
    connection.query("CALL `REDO_MAKMA`.`readGeneralAbsences`(?);"
    ,[IdBranch], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                message:"There is an error"
            })
        }else{
            //temporaly modifying the json since the procedures doesnt return the correct values
            let modifiedJsonArray = [];
            result[0].map((json)=>{
                const {Folio, Nombre, Telefono, CantFaltas} = json;
                const correctJSON = {Folio, Nombre, Telefono, CantFaltas}
                modifiedJsonArray.push(correctJSON)
            })
            res.send( modifiedJsonArray);
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