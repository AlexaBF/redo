const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const {valUserInsertion, valUserModification} = require("../validations/Users.js")
const path = '/users'

//returns a list of the users
router.get(path, (req, res)=>{
    connection.query("CALL `REDO_MAKMA`.`readUsers`();"
    ,[], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                messaage:"There is an error"
            })
        }
        res.send( result[0]);
    })
})

//Creates a new user
router.post(path, valUserInsertion(), (req, res) =>{
    const {name, mail, password, phone, rol, branch } = req.body
    connection.query("CALL `REDO_MAKMA`.`createUser`(?,?,?,?,?,?)",
    [name, mail, password, phone, rol, branch],
    (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false
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
    connection.query("CALL `REDO_MAKMA`.`deleteUser`(?)",
    [id],
    (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false
            })
        }
        else{
            res.json({ done: true });
        }
    })
})

//Update user
router.put(path, valUserModification(),(req,res) =>{
    const { name,mail,phone,rol,branch,id } = req.body
    connection.query("CALL `REDO_MAKMA`.`updateUser`(?,?,?,?,?,?)",
    [name,mail,phone,rol,branch,id],
    (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false
            })
        }
        else{
            res.json({ done: true });
        }
    })
})


module.exports = router;