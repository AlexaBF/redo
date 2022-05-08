const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/requests'

//view the list of requests made by communities in the current month by branch id
router.post(path, (req, res)=>{
    const { id } = req.body
    connection.query("CALL `REDO_MAKMA`.`readRequests`(?);"
    ,[id], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                messaage:"There is an error"
            })
        }else{
            res.send( result[0]);
        }
    })
})

module.exports = router;