const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/absenceReport/:date'

const fluent = require('fluentreports');

const app = express.Router();

const csv = require('csv-parser');
const fs = require('fs');
const fileUpload = require("express-fileupload");

app.use(fileUpload()); //Recibe y procesa
// futuro post
app.get(path, (req, res) => {
    //res.setHeader('Content-Type', 'application/pdf')
    const date = req.params.date;
    connection.query("CALL `REDO_MAKMA`.`absenceReport`(?);",
        [date], (err, result, fields) =>{
            if(err){
                console.log(err)
                res.status(500).send({
                    message:"There is an error"
                })
            }else{
                var mydata = Object.values(JSON.parse(JSON.stringify(result[0])));
                console.log(mydata);
                res.type('application/pdf');
                //Información de la tabla
                var daydetail = function ( report, data ) {
                    const cellWidth = (report.maxX() - report.minX())/7; //Tamaño de la celda
                    const cellW = 30;

                    report.band( [

                        {data: data.Folio, width: 65, zborder:{left:1, right: 1, top: 1, bottom: 0}}, //Columna 1
                        {data: data.Nombre, width: 65, underline: false, zborder:{left:1, right: 1, top: 0, bottom: 1}}, //Columna 2
                        {data: data.Frecuencia, width: 65, underline: false, zborder:{left:1, right: 1, top: 0, bottom: 1}}, //Columna 3
                        {data: data.Dia, width: 60, underline: false, zborder:{left:1, right: 1, top: 0, bottom: 1}}, //Columna 4
                        {data: data.Telefono, width: 60, underline: false, zborder:{left:1, right: 1, top: 0, bottom: 1}}, //Columna 5
                        {data: data.FechaFalta, width: 60, underline: false, zborder:{left:1, right: 1, top: 0, bottom: 1}}, //7
                        {data: data.MotivoFalta, width: 93, underline: false, zborder:{left:1, right: 1, top: 0, bottom: 1}}, //7
                    ], {border:1, width: 0, wrap: 1} );
                };

                //Footer en tabla
                var namefooter = function ( report, data, state ) {
                    report.newLine(); //Espacio de línea

                };

                //Encabezado en tabla
                var nameheader = function ( report, data ) {
                    //report.print("PROPOSAL", {x: 40, y: 70, fontSize: 30, fontBold: true});
                    report.print( data.DiaFalta, {fontBold: true, underline: true} );
                    report.band([
                        {data: 'Folio', width: 70},
                        {data: 'Nombre', width: 65},
                        {data: 'Frecuencia', width: 65},
                        {data: 'Día', width: 70},
                        {data: 'telefono', width: 65},
                        {data: 'Fecha de falta', width: 63},
                        {data: 'Motivo', width: 70}
                    ],{wrap: 1});
                    report.fontNormal();
                    report.newLine(); //Espacio de línea
                    report.bandLine();

                };

                var pageF = function (report,data) {

                    report.print("Sirve?")
                };

                //Encabezado
                const header = (report, data) => {
                    //Confidencial
                    report.print('Confidential', {x: 40, y: 610, rotate: 310, opacity: 0.5, textColor: '#eeeeee', width: 1000, fontSize: 127});

                    // Imagen
                    report.setCurrentY(14);
                    report.image('Bamx2.png', {width: 50});

                    //Titulo
                    report.print('Reporte semanal faltas',{fontSize:20})
                    report.newLine();
                }

                var rpt = new fluent.Report(res)
                    .autoPrint(false) // Optional
                    .pageHeader(header )// Optional
                    //.finalSummary( ["Total id:", "id", 3] )// Optional
                    .data( mydata )	// REQUIRED
                    .detail( daydetail ) // Optional
                    .fontSize(9.5); // Optional

                //Agrupar por nombre
                rpt.groupBy( "DiaFalta" )
                    //Header y footer por tabla
                    .header(nameheader)
                    .footer( namefooter )
                    //.pageFooter( pageF )
                    .render();
            }
        })

})


module.exports = app;