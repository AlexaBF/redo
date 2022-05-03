const express = require('express');
const router = express.Router()
const {connection} = require("../config/mysql.js")
const path = '/branch'

//returns a list of the branches
router.get(path, (req, res)=>{
    connection.query("CALL `REDO_MAKMA`.`readBranches`();"
    ,[], (err, result, fields) =>{
        if(err){
            res.json({
                message:"There is an error"
            })
        }
        else{
            res.json( result[0] );
        }
    })
})



//Creates a new branch
router.post(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

//Deletes a branch
router.delete(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

//Update a branch
router.put(path, (req,res) =>{
    res.send({working:true})
    connection.query("storedProcedure()", [], (err, result, fields) =>{

    })
})

module.exports = router;