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
    const {name,mail,password, phone, rol, branch } = req.body
    console.log(req.body)
    connection.query("CALL `REDO_MAKMA`.`crearUsuario`(?,?,?,?,?,?,?)",
    [name, '', mail, password, phone, rol, branch],
    (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false,
                message:"Hay un error"
            })
        }
        else{
            res.json({ done: true });
        }
    })
    res.status(400).send({done: false, message:"Error with the arguments"})
})

//Deletes an user
router.delete(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

module.exports = router;