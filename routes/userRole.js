const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/userRole'

//returns a list of the user roles
router.get(path, (req, res)=>{
    connection.query("CALL `REDO_MAKMA`.`visualizarRolUsuario`();"
    ,[], (err, result, fields) =>{
        if(err){
            res.json({
                message:"Hay un error"
            })
        }
        else{
            res.json( result[0] );
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

module.exports = router;