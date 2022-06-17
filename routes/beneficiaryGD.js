const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/beneficiaryGD'

//general information of the beneficiaries are added/modified
/*
id(int) == beneficiary id
grant(int) == yes(1) or no(0)
phone(string) == beneficiary's phone
day(int) = Monday(1), Tuesday(2), Wednesday(3),Thursday(4) or Friday(5)
frecuency(int) = Weekly(1), Biweekly(2) or Monthly(3)
*/
router.put(path, (req, res)=>{
    const { id,grant,phone,day,frequency } = req.body
    console.log(req.body)
    connection.query("CALL `REDO_MAKMA`.`UpdateBeneficiaryGD`(?,?,?,?,?);"
    ,[id,grant,phone,day,frecuency], (err, result, fields) =>{
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

