
using { sumo_management as db } from '../db/model'; // Adjust path as needed

// Projections for all entities


service portalService {

entity Employees as projection on db.Employees;
entity EmployeesPersonal as projection on db.EmployeesPersonal;
entity EmployeeBankDetails as projection on db.EmployeeBankDetails;
entity EmployeePayroll as projection on db.EmployeePayroll;
entity EmployeeWorkHistory as projection on db.EmployeeWorkHistory;
entity EmployeeCertifications as projection on db.EmployeeCertifications;
entity EmployeeDocuments as projection on db.EmployeeDocuments;
entity EmployeeSchedule as projection on db.EmployeeSchedule;
entity LeaveRequest as projection on db.LeaveRequest;
entity EmployeePerformance as projection on db.EmployeePerformance;
entity EmployeeTraining as projection on db.EmployeeTraining;
entity EmployeesAuthentication as projection on db.EmployeesAuthentication;
entity EmployeeEventCalendar as projection on db.EmployeeEventCalendar;
entity EmployeeAttendance as projection on db.EmployeeAttendance;
entity EmployeeAssets as projection on db.EmployeeAssets;
entity EmployeeBenefits as projection on db.EmployeeBenefits;
entity EmployeeGrievances as projection on db.EmployeeGrievances;
entity EmployeeExit as projection on db.EmployeeExit;

entity Projects as projection on db.Projects;
entity SubProjects as projection on db.SubProjects;
entity RecruitmentCandidates as projection on db.RecruitmentCandidates;
entity Holidays as projection on db.Holidays;
// login service
action loginCheck(email:String) returns String;

}

