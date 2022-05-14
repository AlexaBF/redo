const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/committeeMember'

//Create a comittee member
router.post(path,(req,res) =>{
    const { name,phone,id } = req.body
    connection.query("CALL `REDO_MAKMA`.`createCommitteeMember`(?,?,?);",[name,phone,id],(err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false
            })
        }
        else{
            res.json( {done:true} );
        }
    })
})

module.exports = router;