const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/requests'

//view the list of requests made by communities in the current month by branch id
router.get(path, (req, res)=>{
    const { branch } = req.token
    connection.query("CALL `REDO_MAKMA`.`readRequests`(?);"
    ,[branch], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                message:"There is an error"
            })
        }else{
            res.send( result[0]);
        }
    })
})

module.exports = router;