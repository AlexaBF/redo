const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/community'


//view the list of active communities and their information by branch
router.get(path, (req, res)=>{
    const { IdBranch } = req.token
    connection.query("CALL `REDO_MAKMA`.`readCommunity`(?);"
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

//create a new community that will be attended by BAMX
router.post(path, (req, res)=>{
    const { name,town,frequency  } = req.body
    const {IdBranch} = req.token
    connection.query("CALL `REDO_MAKMA`.`createCommunity`(?,?,?,?);"
    ,[name,IdBranch,town,frequency], (err, result, fields) =>{
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