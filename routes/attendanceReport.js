const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/attendanceReport/:date'

const fluent = require('fluentreports');

const app = express.Router();

const csv = require('csv-parser');
const fs = require('fs');
const fileUpload = require("express-fileupload");

//app.use(fileUpload()); //Recibe y procesa
// attendance weekly report
app.get(path, (req, res) => {
    //res.setHeader('Content-Type', 'application/pdf')
    const date = req.params.date;
    const { IdBranch } = req.token
    connection.query("CALL `REDO_MAKMA`.`attendanceReport`(?,?);",
        [date,IdBranch], (err, result, fields) => {
            if (err) {
                console.log(err)
                res.status(500).send({
                    message: "There is an error"
                })
            } else {
                var mydata = result[0];
                console.log(mydata);

                res.type('application/pdf');
                //Table information
                var daydetail = function (report, data) {
                    const cellWidth = (report.maxX() - report.minX()) / 6; //width
                    report.band([

                        {data: data.Folio, width: cellWidth, zborder: {left: 1, right: 1, top: 1, bottom: 0}},
                        {data: data.Nombre, width: cellWidth, underline: false, zborder: {left: 1, right: 1, top: 0, bottom: 1}},
                        {data: data.Frecuencia, width: cellWidth, underline: false, zborder: {left: 1, right: 1, top: 0, bottom: 1}},
                        {data: data.Dia, width: cellWidth, underline: false, zborder: {left: 1, right: 1, top: 0, bottom: 1}},
                        {data: data.FechaAsistencia, width: cellWidth, underline: false, zborder: {left: 1, right: 1, top: 0, bottom: 1}},
                        {data: data.DiaSemana, width: cellWidth, underline: false, zborder: {left: 0, right: 1, top: 0, bottom: 1}
                        },
                    ], {border: 1, width: 0, wrap: 1, fill: '#F3F1F4'});


                };

                //Table footer
                var namefooter = function (report, data, state) {
                    report.newLine(); //Space

                };

                //Table Header
                var nameheader = function (report, data) {
                    report.newLine();
                    report.newLine();
                    report.print(data.DiaSemana, {fontBold: true, underline: true});
                    report.band([
                        {data: 'Folio', width: 95},
                        {data: 'Nombre', width: 93},
                        {data: 'Frecuencia', width: 97},
                        {data: 'Día', width: 96},
                        {data: 'Fecha\nasistencia', width: 97},
                        {data: 'Dia\nasistencia', width: 94}
                    ], {border: 0, width: 0, wrap: 1, fontBold: true, fontSize: 12});
                    report.fontNormal();
                    report.bandLine();
                };

//Page footer
                var pageF = function (report, data) {
                    report.pageNumber({align: "right", text: "Página {0}"})

                };

                //Header
                const header = (report, data) => {
                    //Confidencial
                    report.print('Confidencial', {
                        x: 40,
                        y: 610,
                        rotate: 310,
                        opacity: 0.5,
                        textColor: '#eeeeee',
                        width: 1000,
                        fontSize: 127
                    });

                    // Image
                    report.setCurrentY(14);
                    report.image('./images/Bamx.png', {width: 70});

                    //Aditional info
                    report.printedAt({align: "right", text: "Hora: {0}:{1}{2}\nFecha: {3}"});
                    //Title
                    report.print('Reporte de asistencias en punto', {x: 150, y: 90, fontSize: 20, fontBold: true})
                    report.newLine();
                    report.print("Reporte semanal de beneficiarios que asistieron en punto de venta.", {
                        x: 140,
                        y: 110,
                        fontSize: 11
                    });
                    report.newLine();
                }


                var rpt = new fluent.Report(res)
                    .margins(20)
                    .autoPrint(false)
                    .pageHeader(header)
                    .data(mydata)    // REQUIRED
                    .detail(daydetail) // REQUIRED
                    .fontSize(11)

                //GroupBy day
                rpt.groupBy("DiaSemana")
                    .fontSize(11)
                    .header(nameheader)
                    .footer(namefooter)
                    .pageFooter(pageF)
                    .render();
            }
    })
})


module.exports = app;