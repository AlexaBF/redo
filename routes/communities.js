const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/communities'

//create a new community that will be attended by BAMX
router.post(path, (req, res)=>{
    const { name,status,branch,town,frequency  } = req.body
    connection.query("CALL `REDO_MAKMA`.`createCommunity`(?,?,?,?,?);"
    ,[name,status,branch,town,frequency], (err, result, fields) =>{
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

module.exports = router;