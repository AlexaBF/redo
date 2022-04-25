const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/userRole'

//returns a list of the user roles
router.get(path, (req, res)=>{
    const { id } = req.body
    console.log(req.body)
    connection.query("CALL `REDO_MAKMA`.`visualizarUsuario`();"
    [id],
    (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false,
            })
        }
        else{
            res.send( {done: true, payload: result[0]} );
        }
    })
})



//Creates a new user role
router.post(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

//Deletes an user role
router.delete(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

//Modify an user role
router.put(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

module.exports = router;