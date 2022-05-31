const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/communities'

//view the list of active communities by branch
//id == branch id
router.post(path, (req, res)=>{
    const { id } = req.body
    connection.query("CALL `REDO_MAKMA`.`readCommunities`(?);"
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