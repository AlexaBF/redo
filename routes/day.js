const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/day'

//visualize the catalog of attendance days
router.get(path, (req,res) =>{
    connection.query("CALL `REDO_MAKMA`.`readDays`();", [], (err, result, fields) =>{
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

//create a new group of attendance days
router.post(path, (req,res) =>{
    const {day} = req.body
    connection.query("CALL `REDO_MAKMA`.`createDay`(?);", [day], (err, result, fields) =>{
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

//delete a group from the attendance days catalog by their ID
router.delete(path, (req,res) =>{
    const {id} = req.body
    connection.query("CALL `REDO_MAKMA`.`deleteDay`(?);", [id], (err, result, fields) =>{
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

//update a group from the attendance days by their ID and updated name
router.put(path, (req,res) =>{
    const {id,day} = req.body
    connection.query("CALL `REDO_MAKMA`.`updateDay`(?,?);", [id,day], (err, result, fields) =>{
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

