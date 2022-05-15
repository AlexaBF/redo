const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/actBeneficiaries'

//view the list of active beneficiaries by branch
//id == branch id
router.get(path, (req, res)=>{
    const { branch } = req.token
    connection.query("CALL `REDO_MAKMA`.`readActiveBeneficiaries`(?);"
    ,[branch], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                message:"There is an error"
            })
        }else{
            res.send( result[0]);
        }
    })
})

module.exports = router;