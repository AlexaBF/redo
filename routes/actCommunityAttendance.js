const express = require('express');
const router = express.Router()
const {connection} = require('../config/mysql')
const path = '/actCommunityAttendance'


//view the information of the food packages that are being send
//to the communities that are active on the current month
router.get(path,(req,res)=>{
    const {IdBranch} = req.token
    console.log(IdBranch)
    connection.query("CALL `REDO_MAKMA`.`readActiveCommunityAttendance`(?);",
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