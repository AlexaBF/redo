const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/user'

//returns a list of the users
router.get(path, (req, res)=>{
    res.send({working:true})
    connection.query("storedProcedureName", [], (err, result, fields) =>{

    })
})

//Creates a new user
router.post(path,(req,res) =>{
    res.send({working: true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

//Deletes an user
router.delete(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

module.exports = router;