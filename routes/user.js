const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/user'

//returns a list of the users
router.get(path, (req, res)=>{
    connection.query("CALL `REDO_MAKMA`.`visualizarUsuario`();"
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

//Creates a new user
router.post(path,(req,res) =>{
    res.send({working: true})
    connection.query("CALL `REDO_MAKMA`.`crearUsuario`(?,?,?,?,?,?,?)", 
    [req.body.Nombre, req.body.Apellido, req.body.Correo, req.body.Password, req.body.Telefono, req.body.Rol_id, req.body.Sucursal_id], 
    (err, result, fields) =>{
        if(err){
            res.json({
                message:"Hay un error"
            })
        }
        else{
            res.json({ message: true });
        }
    })
})

//Deletes an user
router.delete(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

module.exports = router;