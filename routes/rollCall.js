const express = require('express');
const router = express.Router();
const {connection} = require('../config/mysql')
const path = '/rollCall'

//view the list of beneficiaries and the relevant information
//to do the beneficiaries roll call
router.get(path,(req,res) =>{
    const { IdBranch } = req.token
    connection.query("CALL `REDO_MAKMA`.`readRollCall`(?);",
    [IdBranch],(err, result, fields) =>{
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