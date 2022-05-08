const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/generalAbsences'

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

module.exports = router;