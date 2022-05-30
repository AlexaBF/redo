const express = require('express');
const fileUpload = require('express-fileupload');

const router = express.Router()
const {connection} = require("../config/mysql.js");
const path = '/beneficiaryDocs'

const app = express.Router();

app.use(fileUpload()); //Recibe y procesa

const csv = require('csv-parser');
const fs = require('fs');


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

module.exports = app;
//module.exports = router;

