const { check, validationResult } = require('express-validator')

const validations = {
    validateEmail: check('mail')
        .notEmpty()
        .withMessage('email es requerido')
        .trim()
        .normalizeEmail()
        .isEmail()
        .withMessage('Email invalido'),
    validatePhone: check('phone')
        .notEmpty()
        .withMessage('Telefono es requerido')
        .isLength(12)
        .isNumeric()
        .withMessage('Telefono invalido'),
    validateAlphaOfSize: (field, alias = field, min = 0, max = 80) => (
        check(field)
            .notEmpty()
            .withMessage(`${alias} es requerido`)
            .trim()
            .isLength({min})
            .withMessage(`${alias} no debe de ser menor a ${min}`)
            .isLength({max})
            .withMessage(`${alias} no debe de ser mayor a ${max}`)
            .matches('^[a-zA-Z ]+$')
            .withMessage(`${alias} solo debe contener letras`)
    ),
    validateNumeric: (field, alias = field) => (
        check(field)
            .notEmpty()
            .withMessage(`${alias} es requerido`)
            .isNumeric()
            .withMessage(`${alias} debe ser numerico`)
    ),
}
//Validates the necessary fields from the  json that is posted to /user
module.exports.validateUser = ()=>{
    const  {validateEmail, validatePhone, validateAlphaOfSize, validateNumeric} = validations
    return [
        validateEmail,
        validatePhone,
        validateAlphaOfSize('name','nombre'),
        validateNumeric('branch','Sucursal'),
        validateNumeric('rol'),
        check('password')
            .notEmpty()
            .withMessage('Clave requerida')
            .isLength({min:8})
            .withMessage('La clave debe tener por lo menos 8 digitos'),
        (req, res, next) => {
            const errors = validationResult(req);
            if (!errors.isEmpty())
                return res.status(422).json({done: false, errors: errors.array()});
            next();
    },
    ]
}

