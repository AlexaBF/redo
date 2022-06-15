const express = require('express');
const router = express.Router();
const {connection} = require('../config/mysql.js')
const path = '/town'

//view the list of towns that have communities attending BAMX by states
router.post(path,(req,res)=>{
    const {idState} = req.body
    connection.query("CALL `REDO_MAKMA`.`readTownByState`(?);"
        ,[idState], (err,result,fields)=>{
            if(err){
                console.log(err)
                res.status(500).send({
                    done:false
                })
            }else{
                res.json(result[0]);
            }
        })
})

module.exports = router;