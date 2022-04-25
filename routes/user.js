const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/user'

//returns a list of the users
router.get(path, (req, res)=>{
    connection.query("CALL `REDO_MAKMA`.`visualizarUsuarios`();"
    ,[], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false,
            })
        }
        res.send( {done: true, payload: result[0]} );
    })
})

//Creates a new user
router.post(path,(req,res) =>{
    const {name, mail, password, phone, rol, branch } = req.body
    console.log(req.body)
    connection.query("CALL `REDO_MAKMA`.`crearUsuario`(?,?,?,?,?)",
    [name, mail, password, phone, rol, branch],
    (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false,
            })
        }
        else{
            res.json({ done: true });
        }
    })
})

//Delete user
router.delete(path, (req,res) =>{
    const { id } = req.body
    console.log(req.body)
    connection.query("CALL `REDO_MAKMA`.`eliminarUsuario`(?)",
    [id],
    (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false,
            })
        }
        else{
            res.json({ done: true });
        }
    })
})

//Modify user
router.put(path, (req,res) =>{
    const { name,mail,password,phone,rol,branch,id } = req.body
    console.log(req.body)
    connection.query("CALL `REDO_MAKMA`.`modificarUsuario`(?,?,?,?,?,?,?)",
    [name,mail,password,phone,rol,branch,id],
    (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false,
            })
        }
        else{
            res.json({ done: true });
        }
    })
})


module.exports = router;