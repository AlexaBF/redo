const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/request'

//create a community reuest for food packages
router.post(path, (req, res)=>{
    const { quantity,idCommunity,idCommitteeMember } = req.body
    connection.query("CALL `REDO_MAKMA`.`createRequest`(?,?,?);"
    ,[quantity, idCommunity, idCommitteeMember], (err, result, fields) =>{
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