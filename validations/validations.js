const { check, validationResult } = require('express-validator')

module.exports.Validations = {
    validateEmail: check('mail')
        .notEmpty()
        .withMessage('email es requerido')
        .trim()
        .normalizeEmail()
        .isEmail()
        .withMessage('Email inválido'),
    validatePhone: check('phone')
        .notEmpty()
        .withMessage('Teléfono es requerido')
        .isLength(10)
        .withMessage('Teléfono inválido')
        .isNumeric()
        .withMessage('Teléfono inválido'),
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
            .withMessage(`${alias} debe ser numérico`)
    ),
    validatePassword: (field, alias = "La contraseña") =>(
        check(field)
            .notEmpty()
            .withMessage(`${alias} es requerida`)
            .isLength({min:8})
            .withMessage(`${alias} debe contener por lo menos 8 caracteres`)
    ),
    validatePasswordMatch: () =>(
        check("password", "Las contraseñas son diferentes")
            .custom((value,{req}) => {
                const {confirmationPassword} = req.body;
                if (value !== confirmationPassword){
                    console.log(confirmationPassword,value)
                    return false;
                }
                return true
            })
    )
}
module.exports.ValMiddleware = (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty())
            return res.status(422).json({done: false, errors: errors.array()});
        next();
}
