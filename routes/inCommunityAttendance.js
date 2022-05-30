const express = require('express');
const router = express.Router();
const {connection} = require('../config/mysql');
const path = '/inCommunityAttendance';

//view the information of the food packages that were send
//to the communities on the current month
router.get(path,(req,res)=>{
    const {IdBranch} = req.token
    connection.query("CALL `REDO_MAKMA`.`readInactiveCommunityAttendance`(?);",
    [IdBranch],(err, result,fields)=>{
        if(err){
            console.log(err)
            res.status(500).send({
                message:"There is an error"
            })
        }
        else{
            res.send(result[0]);
        }
    })

})

module.exports = router;