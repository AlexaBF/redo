const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/recordAbsences'

//view the complete list of absences of recent beneficiaries by branch id
router.get(path, (req, res)=>{
    const { branch } = req.token
    connection.query("CALL `REDO_MAKMA`.`readAbsencesRecord`(?);"
    ,[branch], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                message:"There is an error"
            })
        }else{
            const modifiedJsonArray = []
            result[0].map((json)=>{
                const {Folio, Nombre, Colonia, Telefono, Fecha, CanFaltas, Razon, Motivo = "pendiente motivo"} = json
                const correctJson = {Folio, Nombre, Colonia, Telefono, Fecha, CanFaltas, Razon, Motivo}
                modifiedJsonArray.push(correctJson)
            })
            res.send(modifiedJsonArray);
        }
    })
})

module.exports = router;