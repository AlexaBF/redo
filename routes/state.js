const express = require('express');
const router = express.Router();
const {connection} = require('../config/mysql')
const path = '/state'

//view the list of states that have a community attending BAMX
router.get(path,(req,res)=>{
    connection.query("CALL `REDO_MAKMA`.`readStates`();",[],(err,result,fields)=>{
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