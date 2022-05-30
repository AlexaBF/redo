//Validates the necessary fields from the  json that is posted to /user
const {Validations, ValMiddleware} = require("./validations");

module.exports.valCommitteeInsertion = ()=>{
    const  {validatePhone, validateAlphaOfSize, validateNumeric} = Validations
    return [
        validatePhone,
        validateAlphaOfSize('name','nombre'),
        validateNumeric('id'),
        ValMiddleware
    ]
}
