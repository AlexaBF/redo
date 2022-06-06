const express = require('express');
const fileUpload = require('express-fileupload');

const router = express.Router()
const {connection} = require("../config/mysql.js");
const path = '/beneficiaryDoc/:IdBeneficiary'

const app = express.Router();

app.use(fileUpload()); //Recibe y procesa

//NUEVO-obtención de archivos de uno de los beneficiarios
app.get(path, (req, res)=>{
    //console.log(req.body)
    const IdBeneficiary = req.params.IdBeneficiary;
    //const { IdBeneficiary } = req.body
    //name, data, size, mimetype
    connection.query("CALL `REDO_MAKMA`.`readBeneficiaryDoc`(?);"
        ,[IdBeneficiary], (err, result, fields) =>{
            if(err){
                console.log(err)
                res.status(500).send({
                    done:false
                })
            }else{
                //No es res.json
                res.setHeader('Content-Disposition', `attachment; filename="${result[0].name}"`); //Forzar la descarga del archivo  y necesita un nombre (results[0].name)
                res.setHeader('Content-Type', result[0].mimetype) //¿De qué tipo es el conteniodo del archivo?  Porque cada contenido que se sube a internet tiene varios nombres application/
                res.send(result[0].data); //Escribes bytes en el response
                //De esta forma el response es un archivo
            }
        })
})

module.exports = app;
