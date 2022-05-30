const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/frequency'

//visualize the attendance frequency catalog (monthly,biweekly,weekly)
router.get(path, (req,res) =>{
    connection.query("CALL `REDO_MAKMA`.`readFrequencies`();", [], (err, result, fields) =>{
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

//create a new attendance frequency
router.post(path, (req,res) =>{
    const{frequency}=req.body
    connection.query("CALL `REDO_MAKMA`.`createFrequencies`(?);", [frequency], (err, result, fields) =>{
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

//delete an attendance frequency by their ID
router.delete(path, (req,res) =>{
    const{id}=req.body
    console.log(req.body);
    
    connection.query("CALL `REDO_MAKMA`.`deleteFrequency`(?);", [id], (err, result, fields) =>{
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

//update an attendance frequency by their updated name and ID
router.put(path, (req,res)=>{
    const{id,frequency}=req.body
    console.log(req.body)
    connection.query("CALL `REDO_MAKMA`.`updateFrequency`(?,?);", [id,frequency], (err, result, fields) =>{
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

