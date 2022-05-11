const express = require('express');
const router = express.Router();
const {connection} = require('../config/mysql.js')
const path = '/towns'

//view the list of towns that have communities attending BAMX
router.get(path,(req,res)=>{
    connection.query("CALL `REDO_MAKMA`.`readTowns`();",[],(err,result,fields)=>{
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

//create town that has a community that attends BAMX
router.post(path,(req,res)=>{
    const {name,idState} = req.body
    connection.query("CALL `REDO_MAKMA`.`createTown`(?,?);"
    ,[name,idState], (err,result,fields)=>{
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