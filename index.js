const express = require('express')
const cors = require('cors');
const app = express();
const users = require('./routes/users')
const status = require('./routes/status')
const branch = require('./routes/branch')
const userRole = require('./routes/userRole')
const user = require('./routes/user')
const beneficiaries = require('./routes/beneficiaries')
const beneficiary = require('./routes/beneficiary')
const beneficiaryGD = require('./routes/beneficiaryGD')
const beneficiaryDocs = require('./routes/beneficiaryDocs')
const beneficiaryDoc = require('./routes/beneficiaryDoc')
const communityDocs = require('./routes/communityDocs')
const communityDoc = require('./routes/communityDoc')
const frequency = require('./routes/frequency')
const day = require('./routes/day')
const actBeneficiaries = require('./routes/actBeneficiaries')
const inactBeneficiaries = require('./routes/inactBeneficiaries')
const communities = require('./routes/communities')
const absences = require('./routes/absences')
const recorAbsences = require('./routes/recordAbsences')
const requests = require('./routes/requests')
const reasons = require('./routes/reasons')
const towns = require('./routes/towns')
const community = require('./routes/community')
const state = require('./routes/state')
const userBranch = require('./routes/userBranch')
const committeeMembers = require('./routes/committeeMembers')
const request = require('./routes/request')
const committeeMember = require('./routes/committeeMember')
const attendanceJustify = require('./routes/attendanceJustify')
const attendance = require('./routes/attendance')
const justification = require('./routes/justification')
const justifications = require('./routes/justifications')
const rollCall = require('./routes/rollCall')
const actCommunityAttendance = require('./routes/actCommunityAttendance')
const inCommunityAttendance = require('./routes/inCommunityAttendance')
const attendanceReport = require('./routes/attendanceReport')
const absenceReport = require('./routes/absenceReport')
const justificationReport = require('./routes/justificationReport')
const attendanceRecord = require('./routes/attendanceRecord')
const {authMiddleware, login} = require('./routes/authorization.js')
const {auth} = require("mysql/lib/protocol/Auth");
const fileUpload = require("express-fileupload");
app.use(cors())
app.use(fileUpload());

//Routes
const path = '/api'

app.post(path+"/login", express.json(),login)
/*
 */
app.use(express.json(),authMiddleware)
//IMPORTANT: ALL THE ROUTES THAT ARE ADDED UP FROM THE AUTHMIDDLEWARE WILL BE UNPROTECTED
// ADD ALL THE PROTECTED ROUTES BELOW THIS COMMENT
//Files
app.use(path, attendanceReport);
app.use(path, absenceReport);
app.use(path, justificationReport);
app.use(path,communityDocs);
app.use(path,beneficiaryDocs);
app.use(path,beneficiaryDoc);
app.use(path,communityDoc);

//ALL the endpoint with json below this comment
app.use(express.urlencoded({ extended: true })); //Nos permite tomar el contenido del cuerpo
app.use(express.json({type:"application/json"}));  //Para pasarlo a formato json
app.use(path, users);
app.use(path,status);
app.use(path,branch);
app.use(path,userRole);
app.use(path,user);
app.use(path,beneficiaries);
app.use(path,beneficiary);
app.use(path,beneficiaryGD);
app.use(path,frequency);
app.use(path,day);
app.use(path,actBeneficiaries);
app.use(path,inactBeneficiaries);
app.use(path,community);
app.use(path,absences);
app.use(path,recorAbsences);
app.use(path,requests);
app.use(path,reasons);
app.use(path,towns);
app.use(path,communities);
app.use(path,state);
app.use(path,userBranch);
app.use(path,committeeMembers);
app.use(path,request);
app.use(path,committeeMember);
app.use(path,attendanceJustify);
app.use(path,attendance);
app.use(path,justification);
app.use(path,justifications);
app.use(path,actCommunityAttendance);
app.use(path,rollCall);
app.use(path,inCommunityAttendance);
app.use(path,attendanceRecord);
//Servidor
app.set('port', process.env.PORT || 8080)
app.listen(app.get('port'), () => {
    //TODO: PRINT THE CORRECT PORT AND ADDRESS OF THE SERVER
    console.log("Servidor iniciado correctamente");
});