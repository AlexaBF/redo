const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/day'

//visualize the catalog of attendance days
router.get(path, (req,res) =>{
    connection.query("CALL `REDO_MAKMA`.`readDays`();", [], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                message:"There is an error"
            })
        }else{
            res.send(result[0]);
        }
    })
})


module.exports = router;

