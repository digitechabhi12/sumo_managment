const cds = require('@sap/cds');

const loginCheck = async (req, res) => {
    try {
        const username = req.data.email;
        if (!username || username.trim() === "") {
            return "Email is required.";
        }
        const db = await cds.connect.to("db");
        const { EmployeesAuthentication } = cds.entities('sumo_management');
        const empData = await db.run(
            SELECT.one.from(EmployeesAuthentication).where({ username })
        );
        if (!empData) {
            return "User not present.";
        }
        return empData.username;
    } catch (error) {
        return error;
    }
};



const OTPGenerate = async (req, res) => {
    try {
        
       
    } catch (error) {
        return error;
    }
};
module.exports = { loginCheck, OTPGenerate };
