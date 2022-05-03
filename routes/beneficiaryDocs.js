const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/beneficiaryDocs'

//specific documents of the beneficiaries are added/modified
router.put(path, (req, res)=>{
    const { id,badge,socioeconomicStudy } = req.body
    console.log(req.body)
    connection.query("CALL `REDO_MAKMA`.`updateBeneficiaryDocs`(?,?,?);"
    ,[id,badge,socioeconomicStudy], (err, result, fields) =>{
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

