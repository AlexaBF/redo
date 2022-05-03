const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const {validateUser} = require("../lib/validations.js")
const path = '/beneficiary'

//returns relevant information from a specific beneficiary
//this by indicating their branch id and the beneficiary id
router.post(path, (req, res)=>{
    const { idBranch,idBeneficiary } = req.body
    console.log(req.body)
    connection.query("CALL `REDO_MAKMA`.`readBeneficiary`(?,?);"
    ,[idBranch,idBeneficiary], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                messaage:"Hay un error"
            })
        }else{
            res.send( result[0]);
        }
    })
})


module.exports = router;

