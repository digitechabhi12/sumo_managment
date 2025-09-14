using mm_dpde_schema.transactional as transactional from '../db/mm_dpde';

using mm_dpde_master.master as master from '../db/mm_dpde_master';



 service portalService  {
//service ApprovalHubService @(path: '/approval-hub', requires:'authenticated-user') {
    
    entity Requesters              as projection on master.Requester;
    entity Platforms               as projection on master.Platform;
    entity ControlValues           as projection on master.ControlValues;
    entity Approvers               as projection on master.Approvers;
    entity ApprovalRules           as projection on master.ApprovalDetermination;
    entity ApprovalDetermination   as projection on master.ApprovalDetermination;
    entity PartDetails             as projection on master.PartDetails;
    entity ProcessGroupTask        as projection on master.ProcessGroupTask;
    entity Requests                as projection on transactional.Request;
    entity RequestsAP              as projection on transactional.Request;
    entity ReqAttachments          as projection on transactional.ReqAttachment;
    entity SeqTrackers             as projection on transactional.SeqTracker;
    entity ReqFormAP_Transfer      as projection on transactional.ReqFormAP_Transfer;
    entity ProjCostDtl             as projection on transactional.ProjCostDtl;
    entity ReqFormAP_Trans_Details as projection on transactional.ReqFormAP_Trans_Details;
    entity ReqFormAP_Parked_Savings      as projection on transactional.ReqFormAP_Parked_Savings;
    entity ReqFormAP_Invest_Dtl        as projection on transactional.ReqFormAP_Invest_Dtl;
    entity volumeBreakup           as projection on transactional.volumeBreakup;
    entity ReqFormAP_Parked_S      as projection on transactional.ReqFormAP_Parked_S;
    entity ReqFormAP_Invest        as projection on transactional.ReqFormAP_Invest;
    entity Mat_Cost_Dtl            as projection on transactional.Mat_Cost_Dtl;
    entity ReqFormIPM              as projection on transactional.ReqFormIPM;
    entity ReqFormFD               as projection on transactional.ReqFormFD;
    entity ReqFormNB_Details       as projection on transactional.ReqFormNB_Details;
    entity RequestApprovalForm     as projection on transactional.RequestApprovalForm;
    entity ReqForm_Recom_Approver  as projection on transactional.ReqForm_Recom_Approver;
    entity ReqFormISR              as projection on transactional.ReqFormISR;
    entity ReqFormEXP              as projection on transactional.ReqFormEXP;
    // entity PurReqDetail            as projection on transactional.PurReqDetail;
    // entity PurReqLineItems         as projection on transactional.PurReqLineItems;
    //New 
    entity PurReqDetail            as projection on transactional.PurReqDtl;
    entity PurReqLineItems         as projection on transactional.PurReqLineItemsDtl;
    // for image and logo in pdf
    entity imagelogo               as projection on transactional.imgLogo;

    entity ProcessLogs             as projection on transactional.ProcessLog
                                      order by
                                          createdAt asc;

    entity ExpenseReports          as
        projection on transactional.ExpenseReport {
                @UI.Hidden
            key reqID,
                type,
                refNo           as ClaimID,
                status          as Status,
                createdAt       as StartDate,
                modifiedAt      as LastModify,
                createdBy       as InitiatorID,
                createdByDtl    as InitiatorName,
                modifiedBy      as ApprovedBy,
                pendingWith,
                pendingWithName,
                quotationAmount as QuotationAmount,
                approvalAmount  as ApprovedAmount,
                manager         as ManagerID,
                location        as Location,
                costCenter      as CostCentre,
                WBSCode         as WBSCode,
                purpose         as Purpose
        }
        where
            type = 'EXP';

    function getCurrentUser(role : String default '', dept : String default '')                                       returns Approvers;
    function getApproverStages(subType : String, amount : String, natOfExp : String, fApprovers : String)             returns String;
    function seekClarification(reqID : String, question : String, clstage : String, clUser : String)                  returns String;
    function validateApprovers(appR1 : String, appR2 : String, appR3 : String)                                        returns String; //Cost Contigency: NB
    function seekClarified(reqID : String, clarification : String)                                                    returns String;

    function NBBudgetseekClarification(reqID : String, question : String, clstage : String, clUser : String)                  returns String;
    function NBBudgetseekClarified(reqID : String, clarification : String)                                                    returns String;

    //PR
    function TestMail(reqID : String)                                                                                 returns String;
    function IsLastRecommender(reqID : String)                                                                        returns String;
    function getLogs(reqID : String)                                                                                  returns String;
    function getDownloadUrl(fileUrl : String)                                                                         returns String;  //for attachment in GCP 
    function getSSFDtypes() returns String;
    
    function PRseekClarification(reqID: String, question: String, clstage: String, clUser: String)               returns String;
    function PRseekClarified(reqID: String, clarification: String)                                               returns String;

    function getUserId() returns String;

    function getFilters(type: String) returns String;
    action   EXPApproval(reqID : String, action : String, loggedInUser : String, remarks : String, data : ReqFormEXP) returns String;
    action   NBApproval(reqID : String, action : String, remarks : String, data : ReqFormNB_Details)                  returns String;
    action   ApproveRequest(reqID : String, action : String, remarks : String)                                        returns String;
    action   SSFDApproval(reqID : String, action : String, remarks : String)                                          returns String;
    action   ADPDApproval(reqID : String, action : String, remarks : String)                                          returns String;
    // action   ISRApproval(reqID : String, action : String, remarks : String, )                                           returns String;
   action   ISRApproval(reqID : String, action : String, remarks : String, role: String, dept: String)               returns String;
    action OnFileUpload(fileName : String, content : LargeString) returns {
    fileName : String;
    rowCount : Integer;
    data     : LargeString; // serialized JSON
  };
    action   IPMApproval(reqID : String, action : String, remarks : String)                                           returns String;
    action   PRApproval(reqID : String, action : String, remarks : String)                                            returns String;
    action   pdfgenerator(reqID : String)                                                                             returns String;
  
    action   infradata(department : String)                                                                           returns String; // infra 

    action getLoggedInUser(loggedInUser : String)                                                                     returns Approvers;  
    action   sendReminderMail(reqID : String)                                                                         returns {
        success : Boolean;
        message : String;
    };


    function getDepartments(role:String) returns String;
    function getYears() returns String;
}
