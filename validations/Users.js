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
        validatePassword('password', 'contraseñas'),
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
    const {validateNumeric,validatePassword, validatePasswordMatch} = Validations
    return [
        validatePassword('password', 'La contraseña'),
        validatePassword('confirmationPassword', 'contraseña de confirmacion'),
        validateNumeric('id'),
        validatePasswordMatch(),
        ValMiddleware
    ]
}

