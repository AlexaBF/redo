const express = require('express')
const cors = require('cors');
const app = express();
const user = require('./routes/user')
const status = require('./routes/status')
const branch = require('./routes/branch')
const userRole = require('./routes/userRole')

//Routes
const path = '/api'
app.use(path,user);
app.use(path,status);
app.use(path,branch);
app.use(path,userRole);

//Configuration
app.use(cors())
//Que se envíe en formato json
app.use(express.urlencoded({ extended: true })); //Nos permite tomar el contenido del cuerpo
app.use(express.json());  //Para pasarlo a formato json
//Servidor
app.set('port', process.env.PORT || 3000)
app.listen(app.get('port'), () => {
    console.log("Servidor iniciado en el puerto 3000");
});