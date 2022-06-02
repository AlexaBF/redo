const express = require('express');
const fileUpload = require('express-fileupload');

const router = express.Router()
const {connection} = require("../config/mysql.js");
const path = '/beneficiaryDocs'

const app = express.Router();

app.use(fileUpload()); //Recibe y procesa

const csv = require('csv-parser');
const fs = require('fs');

//NUEVO-Subida masiva con archivo de beneficiarios.
app.post(path, (req, res)=>{
    if(!req.files || Object.keys(req.files).length === 0){ //Si no existe el atributo files en el req o si el archivo se encuentra vacío
        return res.status(400).send('No se enviaron archivos');
    }
    let sampleFile = req.files.archivo;
    console.log(req.files);
    sampleFile.mv(`./files/${sampleFile.name}`,err => {
        if(err) {
            return res.status(400).send({message: err})
        }
    })
    //name, data, size, mimetype
    let count = -1;
    fs.createReadStream(`./files/${sampleFile.name}`)
    .pipe(csv())
    .on('data', (row) => {
        count ++;
        console.log(row)
        console.log(count)
        if (Object.keys(row).length===11) {
            connection.query("CALL `REDO_MAKMA`.`beneficiaryDocs`(?,?,?,?,?,?,?,?,?,?,?,?);"
                , [row['FOLIO FAMILIAR'], row['NOMBRE TITULAR'], row.COLONIA, row.DIA, row['F.REGISTRO'], row['F.VENCIMIENTO'],
                    row.ESTADO, row.BECA, row.FRECUENCIA, row.TELEFONO, row.SUCURSAL, count], (err, result, fields) => {
                if (err) {
                    console.log(err)
                    return res.status(500).send({
                        done: false
                    })
                } else {
                    console.log(row['FOLIO FAMILIAR'], row['NOMBRE TITULAR'], row.COLONIA, row.DIA, row['F.REGISTRO'], row['F.VENCIMIENTO'],
                        row.ESTADO, row.BECA, row.FRECUENCIA, row.TELEFONO, row.SUCURSAL, count);
                    console.log( result );
                }
            });
        }
    })
    .on('end', () => {
        console.log('CSV file successfully processed');
        return res.send({done: true});
    });
});



//specific documents of the beneficiaries are added/modified
app.put(path, (req, res)=>{
    if(!req.files || Object.keys(req.files).length === 0){ //Si no existe el atributo files en el req o si el archivo se encuentra vacío
        return res.status(400).send('No se enviaron archivos');
    }
    let sampleFile = req.files.archivo;
    console.log(sampleFile);
    console.log(req.body)
    //name, data, size, mimetype
    connection.query("CALL `REDO_MAKMA`.`updateBeneficiaryDocs`(?,?,?,?,?);"
    ,[req.body.idBeneficiary, sampleFile.name, sampleFile.data, sampleFile.size, sampleFile.mimetype], (err, result, fields) =>{
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


//NUEVO-obtención de archivos de todos los beneficiarios
app.get(path, (req, res)=>{
    console.log(req.body)
    const { IdBranch } = req.token
    //name, data, size, mimetype
    connection.query("CALL `REDO_MAKMA`.`readBeneficiaryDocs`(?);"
        ,[IdBranch], (err, result, fields) =>{
            if(err){
                console.log(err)
                res.status(500).send({
                    done:false
                })
            }else{
                //No es res.json
                res.setHeader('Content-Disposition', `attachment; filename="${results[0].name}"`); //Forzar la descarga del archivo  y necesita un nombre (results[0].name)
                res.setHeader('Content-Type', results[0].mimetype) //¿De qué tipo es el conteniodo del archivo?  Porque cada contenido que se sube a internet tiene varios nombres application/
                res.send(results[0].data); //Escribes bytes en el response
                //De esta forma el response es un archivo
            }
        })
})

module.exports = app;
//module.exports = router;

