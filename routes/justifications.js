const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/justifications'


//view the justifications of the beneficiaries by branch in the current month
router.get(path,(req,res) =>{
    const { branch } = req.body
    connection.query("CALL `REDO_MAKMA`.`readJustificationRecord`(?);",
    [branch],(err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                message:"There is an error"
            })
        }
        else{
            res.send(result[0]);
        }
    })
})

module.exports = router;