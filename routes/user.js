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
                message:"There is an error"
            })
        }
        else{
            res.send( result[0] );
        }
    })
})


//Update a user password
router.put(path, (req,res) =>{
    const {password,id}=req.body
    connection.query("CALL `REDO_MAKMA`.`updateUserPassword`(?,?);", [password,id], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false
            })
        }
        else{
            res.json( {done: true} );
        }
    })
})

module.exports = router;