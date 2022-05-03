const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const {validateUser} = require("../lib/validations.js")
const path = '/beneficiaries'

//returns a list of beneficiaries by branch
router.post(path, (req, res)=>{
    const { id } = req.body
    console.log(req.body)
    connection.query("CALL `REDO_MAKMA`.`readBeneficiaries` (?);"
    ,[id], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                messaage:"Hay un error"
            })
        }else{
            res.send( result[0]);
        }
    })
})

//Gets a new something
router.get(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

//Deletes a beneficiary by their id
router.delete(path, (req,res) =>{
    const {id} = req.body
    console.log(req.body)
    connection.query("CALL `REDO_MAKMA`.`deleteBeneficiary`(?);", [id], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false
            })
        }else{
            res.json( {done:true});
        }

    })
})

//Update a something
router.put(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})


module.exports = router;