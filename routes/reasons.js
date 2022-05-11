const express = require('express');
const router = express.Router()
const {connection} = require('../config/mysql.js')
const path = '/reasons'

//view the list of reasons to justify or not justify an absence
router.post(path,(req,res)=>{
    const {id} = req.body
    connection.query("CALL `REDO_MAKMA`.`readReasons`(?);"
    ,[id], (err,result,fields)=>{
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