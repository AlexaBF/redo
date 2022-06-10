const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const {valCommitteeInsertion} = require("../validations/Committee");
const path = '/committeeMember'


//view the list of committee members with their information
router.get(path,(req,res) =>{
    const { IdBranch } = req.token
    connection.query("CALL `REDO_MAKMA`.`readCommitteeMember`(?);",[IdBranch],(err, result, fields) =>{
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


//Create a comittee member
router.post(path, valCommitteeInsertion(),(req,res) =>{
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