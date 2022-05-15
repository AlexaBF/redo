const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/beneficiaries'

//returns a list of beneficiaries by branch
router.get(path, (req, res)=>{
    const { branch } = req.token
    connection.query("CALL `REDO_MAKMA`.`readBeneficiaries` (?);"
    ,[branch], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                message:"There is an error"
            })
        }else{
            res.send( result[0]);
        }
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

//change beneficiary status to active==1 or inactive==0
router.put(path, (req,res) =>{
    const {id,status}=req.body
    console.log(req.body)
    connection.query("CALL `REDO_MAKMA`.`updateBeneficiaryStatus` (?,?);", [id,status], (err, result, fields) =>{
        if(err){
            console.log(err)
            res.status(500).send({
                done:false
            })
        }else{
            
            res.json({done:true});
        }
    })
})


module.exports = router;