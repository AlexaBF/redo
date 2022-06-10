const express = require('express');
const fileUpload = require('express-fileupload');

const router = express.Router()
const {connection} = require("../config/mysql.js");
const path = '/beneficiaryDoc/:IdBeneficiary'

const app = express.Router();

app.use(fileUpload()); //Recibe y procesa

//NUEVO-obtención de archivos de uno de los beneficiarios
app.get(path, (req, res)=>{
    console.log(req.body)
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
                const mydata = Object.values(JSON.parse(JSON.stringify(result[0])));
                console.log(mydata)
                console.log('\n\n',mydata[0].Nombre)
                //No es res.json
                res.setHeader('Content-Disposition', `attachment; filename="${mydata[0].Nombre}"`); //Forzar la descarga del archivo  y necesita un nombre (results[0].name)
                res.setHeader('Content-Type', mydata[0].Mimetype) //¿De qué tipo es el conteniodo del archivo?  Porque cada contenido que se sube a internet tiene varios nombres application/
                res.send(mydata[0].Data); //Escribes bytes en el response
                //De esta forma el response es un archivo
            }
        })
})

module.exports = app;
