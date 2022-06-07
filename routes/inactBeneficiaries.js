const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/inactBeneficiaries'

//view the list of inactive beneficiaries by branch
//id == branch id
router.get(path, (req, res)=>{
    const { IdBranch } = req.token
    connection.query("CALL `REDO_MAKMA`.`readInactiveBeneficiaries`(?);"
    ,[IdBranch], (err, result, fields) =>{
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