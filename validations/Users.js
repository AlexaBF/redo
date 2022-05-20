//Validates the necessary fields from the  json that is posted to /user
const {Validations, ValMiddleware} = require("./validations");

module.exports.valUserInsertion = ()=>{
    const  {validatePassword,validateEmail, validatePhone, validateAlphaOfSize, validateNumeric} = Validations
    return [
        validateEmail,
        validatePhone,
        validateAlphaOfSize('name','nombre'),
        validateNumeric('branch','sucursal'),
        validateNumeric('rol'),
        validatePassword('password', 'clave'),
        ValMiddleware
    ]
}

module.exports.valUserModification = ()=>{
    const  {validateEmail, validatePhone, validateAlphaOfSize, validateNumeric} = Validations
    return [
        validateEmail,
        validatePhone,
        validateAlphaOfSize('name','nombre'),
        validateNumeric('branch','sucursal'),
        validateNumeric('rol'),
        validateNumeric('id'),
        ValMiddleware
    ]
}

module.exports.valPassModification = () =>{
    const {validatePassword, validatePasswordMatch} = Validations
    return [
        validatePassword('password', 'clave'),
        validatePassword('confirmationPassword', 'clave de confirmacion'),
        validatePasswordMatch(),
        ValMiddleware
    ]
}

