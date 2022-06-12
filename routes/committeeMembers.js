const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/committeeMembers'

//view the list of committee members
router.get(path+'/:idCommunity',(req,res) =>{
    const {idCommunity}= req.params;
    connection.query("CALL `REDO_MAKMA`.`readCommitteeMembers`(?);",[idCommunity],(err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                message:"There is an error"
            })
        }
        else{
            res.send( result[0] );
        }
    })
})

module.exports = router;