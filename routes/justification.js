const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/justification'


//create a justification
router.post(path,(req,res) =>{
    const { date,folio,idReason, textReason='' } = req.body
    console.log(date,folio, idReason,textReason)
    connection.query("CALL `REDO_MAKMA`.`createJustification`(?,?,?,?);",
    [date, folio, Number(idReason), textReason],(err, result, fields) =>{
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