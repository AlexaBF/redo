const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/user'

//returns a single user
router.post(path,(req,res) =>{
    const { id } = req.body
    console.log(req.body)
    connection.query("CALL `REDO_MAKMA`.`readUser`(?);",
    [id],
    (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                message:"Hay un error"
            })
        }
        else{
            res.send( result[0] );
        }
    })
})



//Creates a new something
router.get(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

//Deletes a something
router.delete(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

//Update a something
router.put(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

module.exports = router;