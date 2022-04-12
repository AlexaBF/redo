const { isAlive } = require('../config/mysql');
const express = require("express");
const router = express.Router()

router.get('/health', (req, res) => { //Ruta principal
    if (isAlive()) {
        //todo: change response
        res.send({working: true});
        return;
    }
    res.status(503).send({working: false, message: "The db server is down"})
});

module.exports = router;