const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/inactBeneficiaries'

//view the list of inactive beneficiaries by branch
//id == branch id
router.get(path, (req, res)=>{
    const { branch } = req.token
    connection.query("CALL `REDO_MAKMA`.`readInactiveBeneficiaries`(?);"
    ,[branch], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                message:"There is an error"
            })
        }else{
            const modifiedJsonArray = []
            result[0].map((json)=>{
                const {Folio, Nombre, Colonia, Fecha, Falta} = json
                const correctJson = {Folio, Nombre,  Fecha, Falta}
                modifiedJsonArray.push(correctJson)
            })
            res.send(modifiedJsonArray);
        }
    })
})

module.exports = router;