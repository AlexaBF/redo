const express = require('express');
const fileUpload = require('express-fileupload');

const router = express.Router()
const {connection} = require("../config/mysql.js");
const path = '/communityDoc/:IdReport'

const app = express.Router();

//app.use(fileUpload()); //Recibe y procesa

//NUEVO-obtención de archivos de todos los beneficiarios
app.post(path, (req, res)=>{
    //console.log(req.body)
    const IdReport = req.params.IdReport;
    //const { IdReport } = req.body
    //name, data, size, mimetype
    connection.query("CALL `REDO_MAKMA`.`readCommunityReportDoc`(?);"
        ,[IdReport], (err, result, fields) =>{
            if(err){
                console.log(err)
                res.status(500).send({
                    done:false
                })
            }else{
                const mydata = result[0][0]
                console.log(mydata)
                //No es res.json
                res.setHeader('Content-Disposition', `attachment; filename="${mydata.Nombre}"`); //Forzar la descarga del archivo  y necesita un nombre (results[0].name)
                res.setHeader('Content-Type', mydata.Mimetype) //¿De qué tipo es el conteniodo del archivo?  Porque cada contenido que se sube a internet tiene varios nombres application/
                res.send(mydata.Data); //Escribes bytes en el response
                //De esta forma el response es un archivo
            }
        })
})

module.exports = app;