namespace sumo_management;
using { cuid, managed } from '@sap/cds/common';

// ==================================================================
// ROOT ENTITY
// ==================================================================
entity Employees : cuid, managed {
    key empCode        : String;
    empName            : String;
    managerId          : String;
    role               : String ;

    // Child compositions
    personalDetails    : Composition of one EmployeesPersonal      on personalDetails.empCode = $self.empCode;
    bankDetails        : Composition of one EmployeeBankDetails    on bankDetails.empCode = $self.empCode;
    payrollDetails     : Composition of many EmployeePayroll       on payrollDetails.empCode = $self.empCode;
    workHistory        : Composition of many EmployeeWorkHistory   on workHistory.empCode = $self.empCode;
    certifications     : Composition of many EmployeeCertifications on certifications.empCode = $self.empCode;
    documents          : Composition of many EmployeeDocuments     on documents.empCode = $self.empCode;
    schedules          : Composition of many EmployeeSchedule      on schedules.empCode = $self.empCode;
    leaveRequests      : Composition of many LeaveRequest          on leaveRequests.empCode = $self.empCode;
    performance        : Composition of many EmployeePerformance   on performance.empCode = $self.empCode;
    trainings          : Composition of many EmployeeTraining      on trainings.empCode = $self.empCode;
    auth               : Composition of one EmployeesAuthentication on auth.empCode = $self.empCode;
    calendarEvents     : Composition of many EmployeeEventCalendar on calendarEvents.empCode = $self.empCode;
    attendance         : Composition of many EmployeeAttendance    on attendance.empCode = $self.empCode;
    assets             : Composition of many EmployeeAssets        on assets.empCode = $self.empCode;
    benefits           : Composition of many EmployeeBenefits      on benefits.empCode = $self.empCode;
    grievances         : Composition of many EmployeeGrievances    on grievances.empCode = $self.empCode;
    exitDetails        : Composition of one EmployeeExit           on exitDetails.empCode = $self.empCode;
}

// ==================================================================
// EMPLOYEE SUB TABLES
// ==================================================================
entity EmployeesPersonal : cuid, managed {
    empCode     : String;
    email       : String;
    mobileNo    : String;
    DOB         : Date;
    gender      : String ;
    baseLocation: String;
    designation : String;
    DOJ         : Date;
    fatherName  : String;
    address     : String;
    UANno       : String;
    PANno       : String;
    profilePic  : String; // Path/URL to photo

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeeBankDetails : cuid, managed {
    empCode     : String;
    BankAcNo    : String;
    ifscCode    : String;
    bankName    : String;
    accountType : String ;
    bankAcName  : String;

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeePayroll : cuid, managed {
    empCode     : String;
    salary      : Decimal(10,2);
    bonus       : Decimal(10,2);
    deductions  : Decimal(10,2);
    pfNumber    : String;
    esiNumber   : String;
    payDate     : DateTime;

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeeWorkHistory : cuid, managed {
    empCode     : String;
    companyName : String;
    designation : String;
    startDate   : Date;
    endDate     : Date;
    reasonForLeaving : String;

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeeCertifications : cuid, managed {
    empCode     : String;
    certificateName : String;
    authority   : String;
    validFrom   : Date;
    validTo     : Date;

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeeDocuments : cuid, managed {
    empCode     : String;
    documentType: String;
    filePath    : String;
    uploadedAt  : DateTime;

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeeSchedule : cuid, managed {
    empCode     : String;
    date        : Date;
    startDateTime : DateTime;
    endDateTime   : DateTime;
    type        : String;
    description : String(255);

    emp : Association to Employees on emp.empCode = empCode;
}

entity LeaveRequest : cuid, managed {
    empCode     : String;
    leaveType   : String;
    startDate   : Date;
    endDate     : Date;
    reason      : String(255);
    status      : String ;
    appliedAt   : DateTime;
    approvedBy  : String;
    approvalDate: DateTime;

    emp         : Association to Employees on emp.empCode = empCode;
    approvedByEmp : Association to Employees on approvedByEmp.empCode = approvedBy;
}

entity EmployeePerformance : cuid, managed {
    empCode     : String;
    reviewPeriod: String;
    rating      : String;
    reviewer    : String;
    comments    : String(500);

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeeTraining : cuid, managed {
    empCode     : String;
    trainingName: String;
    provider    : String;
    startDate   : Date;
    endDate     : Date;
    status      : String ;

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeesAuthentication : cuid, managed {
    empCode     : String;
    username    : String;
    password    : String;

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeeEventCalendar : cuid, managed {
    empCode     : String;
    eventDate   : Date;
    eventType   : String;
    description : String(255);

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeeAttendance : cuid, managed {
    empCode       : String;
    attendanceDate: Date;
    checkInTime   : DateTime;
    checkOutTime  : DateTime;
    workHours     : Decimal(5,2);
    overtime      : Decimal(5,2);
    status        : String ;

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeeAssets : cuid, managed {
    empCode     : String;
    assetTag    : String;
    assetType   : String ;
    serialNo    : String;
    issuedDate  : DateTime;
    returnDate  : DateTime;
    status      : String ;

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeeBenefits : cuid, managed {
    empCode     : String;
    benefitType : String ;
    provider    : String;
    coverageStart : DateTime;
    coverageEnd   : DateTime;
    remarks     : String(255);

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeeGrievances : cuid, managed {
    empCode     : String;
    grievanceType : String ;
    description : String(500);
    status      : String ;
    submittedAt : DateTime;
    resolvedAt  : DateTime;

    emp : Association to Employees on emp.empCode = empCode;
}

entity EmployeeExit : cuid, managed {
    empCode         : String;
    resignationDate : DateTime;
    lastWorkingDay  : DateTime;
    reason          : String(255);
    exitInterview   : String(500);
    status          : String ;

    emp : Association to Employees on emp.empCode = empCode;
}

// ==================================================================
// NON-EMPLOYEE TABLES
// ==================================================================
entity Projects : cuid, managed {
    key projectId  : String;
    projectName    : String;
    clientName     : String;
    description    : String;
    urgency        : String ;
    status         : String ;
    startDate      : DateTime;
    endDate        : DateTime;
    createdBy      : String;
    modifiedBy     : String;

}

entity SubProjects : cuid, managed {
    key moduleId   : String;
    projectId      : String;
    moduleName     : String;
    assignedToE    : String;
    projectManagerId : String;
    timeAssigned   : String;
    moduleStatus   : String ;
    startDate      : DateTime;
    endDate        : DateTime;
    createdBy      : String;
    modifiedBy     : String;


}

entity RecruitmentCandidates : cuid, managed {
    candidateName : String;
    email         : String;
    mobileNo      : String;
    appliedFor    : String;
    resumePath    : String;
    status        : String ;
    appliedAt     : DateTime;
}
entity Holidays : cuid, managed {
    holidayName   : String;
    holidayDate   : Date;
    description   : String;
    type          : String ;
}

