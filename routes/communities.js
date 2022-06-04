const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/communities'

//view the list of active communities by branch
router.get(path, (req, res)=>{
    const { IdBranch } = req.token
    connection.query("CALL `REDO_MAKMA`.`readCommunities`(?);"
    ,[IdBranch], (err, result, fields) =>{
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