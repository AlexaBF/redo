const express = require('express');
const fileUpload = require('express-fileupload');

const router = express.Router()
const {connection} = require("../config/mysql.js");
const path = '/communityDocs'

const app = express.Router();

//app.use(fileUpload()); //Recibe y procesa

//specific documents of the beneficiaries are added/modified
app.put(path, (req, res)=>{
    if(!req.files || Object.keys(req.files).length === 0){ //Si no existe el atributo files en el req o si el archivo se encuentra vacío
        return res.status(400).send('No se enviaron archivos');
    }
    let sampleFile = req.files.file;
    //console.log(req.body)
    const { IdReport, Signatures } = req.body
    console.log(IdReport, Signatures, sampleFile)
    //name, data, size, mimetype
    connection.query("CALL `REDO_MAKMA`.`updateCommunityReportDocs`(?,?,?,?,?,?);"
        ,[ IdReport, Signatures, sampleFile.name, sampleFile.data, sampleFile.size, sampleFile.mimetype], (err, result, fields) =>{
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




//get the attendance list of all the reports
app.post(path, (req, res)=>{
    console.log(req.body)
    const { IdBranch } = req.token
    const { Status } = req.body
    //name, data, size, mimetype
    connection.query("CALL `REDO_MAKMA`.`readCommunityReportDocs`(?, ?);"
        ,[IdBranch, Status], (err, result, fields) =>{
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