using {
  cuid,
  managed
} from '@sap/cds/common';
using {mm_dpde_master.master.ProcessGroupTask} from './mm_dpde_master';

namespace mm_dpde_schema;

context transactional {
  entity Request : managed {
    key reqID           : String;
        refNo           : String;
        createdByDtl    : String;
        pendingWith     : String;
        stage           : String;
        status          : String;
        type            : String;
        // subType         : String;
        pendingWithName : String;
        remarks         : String(4000);
        groupApprover   : Association to ProcessGroupTask
                            on  groupApprover.stage     = $self.stage
                            and groupApprover.processId = type;
        // groupApprover   : Association to ProcessGroupTask on groupApprover.stage=$self.stage and groupApprover.processId = type;
        // Associations to the detail entities
        adpdDtl         : Composition of one ReqFormAP_Transfer
                            on adpdDtl.reqID = $self.reqID;
        ssfdDtl         : Composition of one ReqFormFD
                            on ssfdDtl.reqID = $self.reqID;
        ipmDtl          : Composition of one ReqFormIPM
                            on ipmDtl.reqID = $self.reqID;
        newDtl          : Composition of one ReqFormNB_Details //TODO : camelCase : changed prev : newdtl
                            on newDtl.reqID = $self.reqID;
        // addbd1         : Composition of one ReqFormAB_Details
        //on addbd1.reqID =$self.reqID;

        infraDtl        : Composition of one ReqFormISR
                            on infraDtl.reqID = $self.reqID;
        processLogs     : Composition of many ProcessLog
                            on processLogs.reqID = $self.reqID;
        recomApprovers  : Composition of many ReqForm_Recom_Approver
                            on recomApprovers.reqID = $self.reqID;
        attachments     : Composition of many ReqAttachment
                            on attachments.reqID = $self.reqID;
        approvalDtl     : Composition of one RequestApprovalForm
                            on approvalDtl.reqID = $self.reqID;
        expenseDtl      : Composition of one ReqFormEXP
                            on expenseDtl.reqID = $self.reqID;
        //Changing 1, Modify PR_Header(Pascal)
        prDtl           : Composition of one PurReqDtl
                            on prDtl.reqID = $self.reqID

  }

  entity ReqFormAP_Transfer {
    key reqID            : String;
        subType          : String;
        initiator        : String; //TODO : camelCase    /Initiator
        project          : String; //TODO : camelCase    //Project
        projectDesc      : String;
        justification    : String(1050); //TODO : camelCase   //Justification
        transType        : String;
        natureOfExpense  : String;
        natureOfApproval : String; //used in Exisgency
        platform         : String; //TODO : camelCase   //Platform
        forum            : String; //TODO : camelCase    //Forum
        projFinHead      : String;
        sopDate          : String; //Pre-Project & Exisgency
        // Approver Roles as simple strings
        CPH              : String;
        PEH              : String;
        PPM              : String;
        PNH              : String;
        PPH              : String;
        PFH              : String;
        finMember        : String;
        SrGM             : String; //discuss
        SrVP             : String; //discuss
        onBehalfFlag     : Boolean;
        contingIOM       : Boolean; //TODO : camelCase  //contingIOM
        impactOnMatFlag  : Boolean; //TODO : camelCase  //impactOnMatFlag
        initiationFlag   : String; //TODO : camelCase   //InitiationFlag
        initiationType   : String;
        selfDecFlag      : Boolean;
        finalApprover1   : String; //TODO : camelCase   //FinalApprover1
        finalApprover2   : String; //TODO : camelCase    //FinalApprover1
        finalApprover3   : String; //TODO : camelCase    //FinalApprover1
        finCaseImpact    : String(500);
        preAmount        : String;
        preRemarks       : String;


        expenseDtl       : Composition of many ReqFormAP_Trans_Details
                             on expenseDtl.reqID = $self.reqID;
        parkedSDtl       : Composition of many ReqFormAP_Parked_S
                             on parkedSDtl.reqID = $self.reqID;
        investDtl        : Composition of many ReqFormAP_Invest
                             on investDtl.reqID = $self.reqID;
        parkedSDetail       : Composition of many ReqFormAP_Parked_Savings
                             on parkedSDetail.reqID = $self.reqID;
        investDetail        : Composition of many ReqFormAP_Invest_Dtl
                             on investDetail.reqID = $self.reqID;
        projCostDtl      : Composition of many ProjCostDtl //TODO : camelCase  //ProjCostDtl
                             on projCostDtl.reqID = $self.reqID;
        matcostDtl       : Composition of many Mat_Cost_Dtl //TODO : camelCase
                             on matcostDtl.reqID = $self.reqID;
        volBreakup       : Composition of many volumeBreakup //TODO : camelCase
                             on volBreakup.reqID = $self.reqID;
  }

  entity ProjCostDtl : cuid {
    reqID                 : String;
    capex                 : String;
    revenue               : String;
    totalProjCost         : String;
    tenPercentOfTotalCost : String;
  }

  entity Mat_Cost_Dtl : cuid {
    reqID        : String;
    item         : String;
    vehicleLevel : String;
    ptdLevel     : String;
    totalLevel   : String;
  }

  entity ReqFormAP_Trans_Details : cuid {
    reqID         : String;
    fromWBSCode   : String;
    toWBSCode     : String;
    fromWBSLoc    : String;
    toWBSLoc      : String;
    fromWBSLevel  : String;
    toWBSLevel    : String;
    // Financial Fields
    capexNRT      : Decimal(10, 2);
    capexLanded   : Decimal(10, 2);
    revenueNRT    : Decimal(10, 2);
    revenueLanded : Decimal(10, 2);
    totalNRT      : Decimal(10, 2);
    totalLanded   : Decimal(10, 2);
    remarks       : String(2000);
    //Cont/Parked/Exigency/BudgetAdvancement/Cost Overrun
    WBSCode       : String;
    WBSLoc        : String;
    WBSLevel      : String;
  }

  //Contigency Form
  entity ReqFormAP_Parked_S {
    key reqID                    : String;
        level                    : String;
        WBSCode                  : String;
        priorBalance             : String;
        transfAmountCurrApproval : String;
        balancePostTransfer      : String;
        remarks                  : String(2000);
  }


  //Used in Pre-Project & Cost Overrun
  entity ReqFormAP_Invest {
    key reqID           : String;
        natureOfExpense : String;
        level           : String;
        capex           : String;
        revenue         : String;
        total           : String;
        remarks         : String(2000);
  }

  entity ReqFormAP_Parked_Savings : cuid {
        reqID                    : String;
        level                    : String;
        WBSCode                  : String;
        priorBalance             : String;
        transfAmountCurrApproval : String;
        balancePostTransfer      : String;
        remarks                  : String(2000);
  }


  //Used in Pre-Project & Cost Overrun
  entity ReqFormAP_Invest_Dtl : cuid {
        reqID           : String;
        natureOfExpense : String;
        level           : String;
        capex           : String;
        revenue         : String;
        total           : String;
        remarks         : String(2000);
  }


  entity ReqFormFD {
    key reqID            : String;
        subType          : String;
        division         : String;
        puDept           : String;
        hod              : String;
        loc              : String;
        projName         : String;
        itemRequiredDesc : String(500); //item1 +item2
        budgetRequired   : Decimal(10, 2);
        irr              : String;
        market           : String;
        implDt           : DateTime;
        enggHours        : String;
        remarks          : String(2000);
        background       : String(1500);
        justification    : String(1500);
        deliverables     : String(1500);
        capitalBudget    : Decimal(10, 2);
        revenueBudget    : Decimal(10, 2);
        personnelCost    : Decimal(10, 2);
        selectedApprover : String;
        WBSNumber        : String;
        costCentre       : String;
        initDt           : String; //inition date
  }

  entity ReqFormIPM {
    key reqID          : String;
        email          : String;
        requesterToken : String; //need to discuss
        dept           : String;
        accDocNo       : String;
        PO             : String;
        vendorCode     : String;
        createdDate    : String;
        vendorName     : String;
        invoiceNumber  : String;
        costCenter     : String;
        WBS            : String;
        requester      : String;
        paymentOption  : String;
        paymentType    : String;
        poNonPo        : String; //NEW: Change this  : PONonPO
        paymentTerms   : String;
        buyerRequester : String;
        buyerHOD       : String;
        paymentDt      : DateTime; //TODO //Date -> DateTime
        baseAmount     : Integer;
        totalAmount    : Decimal(15, 2);
        GST            : Decimal(15, 2);
        TDS            : Decimal(15, 2);
  }

  entity ReqFormISR {
    key reqID          : String;
        subType        : String;
        initiator      : String;
        initiationDt   : DateTime; //TODO //Date -> DateTime
        loc            : String; //location
        WBSCode        : String;
        costCenter     : String;
        dept           : String;
        approver       : String;
        typeOfWaste    : String;
        drivernameFrs  : String;
        moblienoFrs    : String;
        requirementDtl : Composition of many ReqFormISR_Vehicle_Details
                           on requirementDtl.reqID = $self.reqID;

  }

  entity ReqFormISR_Vehicle_Details : cuid {
    reqID        : String;
    vehicleNo    : String; //can be merged in binNo
    projectNo    : String; //can be merged in partNo
    productDesc  : String; //can be merged in partDesc
    partDesc     : String;
    partNo       : String;
    binNo        : String;
    price        : String;
    UOM          : String;
    tentativeWt  : String;
    weighmentWt  : String;
    requestedQty : String;
    approvedQty  : String;
    issuedQty    : String;
  }


  //Check the useCase : ADPD
  entity ReqForm_Recom_Approver : cuid {
    reqID     : String;
    role      : String; //TODO : camelCase  //Role
    approvers : String; //TODO : camelCase  //Approvers
    name      : String;
    userId    : String;
    email     : String;
  }

  entity ProcessLog : cuid, managed {
    reqID         : String;
    stage         : String;
    userName      : String;
    userEmail     : String;
    status        : String;
    role          : String;
    receivedDt    : DateTime;
    completionDt  : DateTime;
    remarks       : String(4000);
    logType       : String; //SC
    question      : String;
    clarification : String;
    clStage       : String; // TODO : camelCase ///cl_stage
    clUser        : String;
    clUserName    : String;
  };

  entity SeqTracker {
    key projectName : String;
        lastSeq     : Integer;
  }

  entity ReqFormNB_Details : ReqFormAB_Details {
    key reqID                : String;
        subType              : String;
        creationDate         : DateTime; //TODO //Date -> DateTime
        dept                 : String;
        projectDesc          : String;
        implDate             : DateTime; //TODO //Date -> DateTime
        irrPaybacks          : String;
        objective            : String(250);
        background           : String(1000);
        proposal             : String(1000);
        deliverables         : String(375);
        captlBudget          : Decimal;
        revBudget            : Decimal;
        totalProjCost        : Decimal;
        seekApproval         : Decimal;
        contactPerson        : String;
        contactNo            : String;
        remarks              : String(2000);
        recommAuth           : Integer;
        wbsNo                : String;
        approvedBy           : String;
        approverR1Name       : String;
        approverR2Name       : String;
        approverR3Name       : String;
        approverR1           : String;
        approverR2           : String;
        approverR3           : String;
        recomApprover1       : String;
        recomApprover2       : String;
        recomApprover3       : String;
        recomApprover4       : String;
        recomApprover5       : String;
        recomApprover6       : String;
        nabDiv               : String; //NEW:Change this and below  //NABDiv
        nabLoc               : String; //NEW:Change //NABLoc
        nabContValue         : Decimal; //NEW:Change this    //NABcontValue
        nabProjCode          : String; //NEW:Change this    //NABprojCode
        corpTeamMem          : String;
        amount               : String; //For Corporate Stage
        lakhsInput           : Decimal; //TODO : camelCase   //LakhsInput
        assignedTo           : String;
        selectedRecommenders : array of String;
        CPEapprovedProjCost  : String; //CPE Approved Project Cost : Corporate
        CPEapprovedCapexCont : String; //CPE Approved CAPEX including Contigency : Corporate
  }


  aspect ReqFormAB_Details {
    origIrr        : String;
    revIrr         : String;
    itemDesc       : String;
    fdBudgetTrans  : Boolean;
    fdContingency  : Boolean;
    fdSavings      : Boolean;
    fdOverrun      : Boolean;
    fdAdvance      : Boolean;
    addlBudget     : Decimal(10, 2);
    budgetTrans    : Decimal(10, 2);
    bTfromWbs      : String; //Budget Transfer from WBS
    bTtoWbs        : String; //Budget Transfer to WBS
    contReq        : Decimal(10, 2);
    costOverrun    : Decimal(10, 2);
    contAllowed    : Decimal(10, 2);
    utilised       : Decimal(10, 2);
    available      : Decimal(10, 2);
    savings        : Decimal(10, 2);
    savingsFromWbs : String;
    savingsToWbs   : String;
    approvalType   : String;
    capexAdvance   : Decimal(10, 2);
    contingencyAdv : Decimal(10, 2);
    capexApproved  : Decimal(10, 2);
    capexTotal     : Decimal(10, 2);

  }

  @cds.server.body_parser.limit: '10mb'
  entity ReqAttachment : cuid, managed {
    @Core.ContentDisposition.Filename: fileName
    // @Core.MediaType                  : mediaType
    content        : LargeBinary;

    @Core.IsMediaType                : true
    mediaType      : String;
    fileName       : String;

    @Core.IsURL  @Core.MediaType: mediaType
    fileUrl        : String;
    reqID          : String;
    docCategory    : String; //TODO : camelCase   //doc_Category
    uploadedByName : String; // These fields added to track uploader info
    uploadedByID   : String; // These fields added to track uploader info
  };

  entity RequestApprovalForm {
    key reqID            : String;
        capNumber        : String; // Auto-generated
        project          : String;
        models           : String;
        erNumber         : String;
        projectDesc      : String;
        changeDesc       : String(2000);
        reason           : String(2000);
        annualImpact     : Decimal(10, 2);
        toolingCapex     : Decimal(10, 2);
        aggregate        : String; // Dropdown
        budgetProvision  : String; // Dropdown
        warrantyCost     : String; // Dropdown
        changeCategory   : String; // Dropdown
        warrantyRemarks  : String(2000);
        costImpactBasic  : Decimal(10, 2);
        costImpactLanded : Decimal(10, 2);
        fieldQuality     : String; // Dropdown
        applicableModels : String; // Dropdown
        pveLead          : String; // Search and select
        ptdCdmm          : Boolean; //TODO : camelCase //ptd_cdmm
        verifiedBy       : String;
        parts            : Composition of many CAPartDetail
                             on parts.reqID = $self.reqID;
  };

  entity CAPartDetail : cuid {
    reqID                  : String;
    oldPartNumber          : String;
    oldPartManufacturer    : String;
    oldPartChangeLetter    : String;
    oldPartCapacityPerYear : String;
    newPartNumber          : String;
    newPartNomenclature    : String;
    newPartChangeLetter    : String;
    newPartCapacityPerYear : String;
  }

  entity ReqFormEXP {
    key reqID           : String;
        location        : String;
        costCenter      : String;
        WBSCode         : String;
        purpose         : String;
        quotationAmount : String;
        manager         : String;
        approvalAmount  : String;
  }


  // //Change PR_Header name
  // entity PurReqDetail {
  //   key PR_Num            : String;
  //       reqID             : String;
  //       department        : String;
  //       createdBy         : String;
  //       location          : String;
  //       dated             : String;
  //       plant             : String;
  //       budgetCode        : String;
  //       description       : String;
  //       documentType      : String;
  //       totalValue        : Decimal(15, 2);
  //       totalBudget       : Decimal(15, 2);
  //       cumTentAmount     : Decimal(15, 2);
  //       cumRelAmount      : Decimal(15, 2);
  //       budgetBalance     : Decimal(15, 2);
  //       project           : String;
  //       budgetValue       : Decimal(15, 2);
  //       reqTokenNo        : String;
  //       reqName           : String;
  //       initiatorRem      : String(200);
  //       selectedFlow      : String(5)
  //       @assert.range: [
  //         'MRV',
  //         'SSU',
  //         'IT',
  //         'OTH'
  //       ];
  //       otherSource:   String;
  //       genRemark         : String;
  //       sanctionBy        : String;
  //       clearedBy         : String;
  //       justNote          : String(500);
  //       items             : Composition of many PurReqLineItems
  //                             on items.PR_Line = $self;
  //       quotationType     : String;
  //       fromDate          : DateTime;
  //       toDate            : DateTime;
  //       capexOpex         : String;
  //       category          : String;
  //       subCategory       : String;
  //       sector            : String;
  //       subSector         : String;
  //       recomApprover1    : String;
  //       recomApprover2    : String;
  //       recomApprover3    : String;
  //       recomApprover4    : String;
  //       recomApprover5    : String;
  //       recomApprover6    : String;
  //       userContact       : String;
  //       mrvDepartment     : String; //dropdown
  //       function          : String;
  //       commodity         : String; //dropdown
  //       descProcurement   : String;
  //       protoAlliedServ   : String; //dropdown
  //       sources           : String; //dropdown
  //       mrvBudget         : String;
  //       natureOfExp       : String;
  //       techSpecification : String;
  //       delLocation       : String; //dropdown
  //       specialCase       : String;
  //       typePR            : String; //dropdown
  //       stage1Rep         : String;
  //       stage2Rep         : String;
  //       recomVendor       : String; //dropdown
  //       reasonRecom       : String;
  //       lowestVendor      : String;
  //       vendorOrgName     : String; //Sources/ ARC
  //       vendorProcType    : String;
  //       vendorOrgName1    : String;
  //       vendorQuote1      : String;
  //       vendorProcType1   : String; //dropdown Sources/ 2 quotes(Commodity/others)
  //       vendorOrgName2    : String;
  //       vendorQuote2      : String;
  //       vendorProcType2   : String; //dropdown
  //       vendorOrgName3    : String;
  //       vendorQuote3      : String;
  //       vendorProcType3   : String; //dropdown Sources /3 Quotes
  //       oemRef            : String;
  //       quoteValid        : String;
  //       repeatOrderNo     : String;
  //       singleSourceAppr  : String;
  //       initialQuoteRef   : String;
  //       initialQuoteDate  : String;
  //       initialQuoteVal   : String;
  //       vendorRep         : String;
  //       finalQuoteRef     : String;
  //       finalQuoteDate    : String;
  //       finalQuoteValue   : String;
  //       deliveryWeek      : String;
  //       agreedPacking     : String;
  //       agreedTransport   : String;
  //       perDiscOffered    : String;
  //       agreedWarranty    : String;
  //       mailId            : String;
  //       name              : String;
  //       contactNo         : String;
  //       address1          : String;
  //       state             : String;
  //       pinCode           : String;
  //       accounts          : String;
  //       vendorCode : String;
  //       finalizedVendCode : String;
  //       vendorPinQuote    : String;
  //       vendorGstQuote    : String;
  //       selectAgent       : String;
  //       remarks           : String;
  //       amendmentRem      : String;
  //       repeatOrderDate :String;
  //       selectedReason:String;
  //       vendorOrgName4:String;
  //       vendorOrgName5:String;
  //       vendorProcType4:String;
  //       vendorProcType5:String;
  //       singelQuote:String;
  //       vendorQuote4:String;
  //       vendorQuote5:String;
  //       arcSerialNo:String;
  //       confirmDate:String;
  //       orderFrom:String;
  //       amdVersion:String;
  //       servCorrectness   : Boolean;
  //       specPartNumber    : Boolean;
  //       unitRateAgreement : Boolean;
  //       freightItemMade   : Boolean;
  //       repeatOrderMatch  : Boolean;
  //       vend1QuoteCorrect : Boolean;
  //       vend2QuoteCorrect : Boolean;
  //       vend3QuoteCorrect : Boolean;
  //       drawings          : Boolean;
  //       quotationMapping  : Boolean;
  //       amcWorkSignedOff  : Boolean;
  //       provCleared       : Boolean;
  // }

  // //PR Child table for line items and value details
  // //Change entity name and association as well
  // entity PurReqLineItems {
  //       key ID : String;
  //       PR_Line          : Association to PurReqDetail;
  //       SN              : String;
  //       itemNo          : String;
  //       itemDescription : String;
  //       quantity        : Integer;
  //       UorM            : String;
  //       rateInr         : Decimal(15, 2);
  //       totalVal        : Decimal(15, 2);
  //       glCode          : String;
  //       plant           : String;
  //       WBSCode         : String;
  //       itemCat         : String;
  //       natureOfAct     : String;
  // }


  // PR new tables ////////////////////////////////////////////////////////
  // entity PurReqDetail {

  //   key PR_Num                      : String;
  //       version                     : String;
  //       reason                      : String;
  //       reqID                       : String;
  //       department                  : String;
  //       createdBy                   : String;
  //       location                    : String;
  //       dated                       : String;
  //       plant                       : String;
  //       budgetCode                  : String;
  //       description                 : String;
  //       documentType                : String;
  //       totalValue                  : Decimal(15, 2);
  //       totalBudget                 : Decimal(15, 2);
  //       cumTentAmount               : Decimal(15, 2);
  //       cumRelAmount                : Decimal(15, 2);
  //       budgetBalance               : String;
  //       project                     : String;
  //       budgetValue                 : Decimal(15, 2);
  //       reqTokenNo                  : String;
  //       reqName                     : String;
  //       initiatorRem                : String(1000);
  //       selectedFlow                : String(5);
  //       otherSource                 : String;
  //       genRemark                   : String;
  //       sanctionBy                  : String;
  //       clearedBy                   : String;
  //       justNote                    : String(600);
  //       items                       : Composition of many PurReqLineItems
  //                                       on items.PR_Line = $self;
  //       quotationType               : String;
  //       fromDate                    : DateTime;
  //       toDate                      : DateTime;
  //       capexOpex                   : String;
  //       category                    : String;
  //       subCategory                 : String;
  //       sector                      : String;
  //       subSector                   : String;
  //       userContact                 : String;
  //       mrvDepartment               : String; //dropdown
  //       function                    : String;
  //       commodity                   : String; //dropdown
  //       descProcurement             : String(1020);
  //       protoAlliedServ             : String; //dropdown
  //       sources                     : String; //dropdown
  //       mrvBudget                   : String;
  //       natureOfExp                 : String;
  //       techSpecification           : String;
  //       delLocation                 : String(500); //dropdown
  //       specialCase                 : String(500);
  //       typePR                      : String; //dropdown
  //       stage1Rep                   : String;
  //       stage2Rep                   : String;
  //       recomVendor                 : String(500); //dropdown
  //       reasonRecom                 : String(1000);
  //       recomApprover1              : String;
  //       recomApprover2              : String;
  //       recomApprover3              : String;
  //       recomApprover4              : String;
  //       recomApprover5              : String;
  //       recomApprover6              : String;
  //       lowestVendor                : String;
  //       vendorOrgName               : String; //Sources/ ARC
  //       vendorProcType              : String;
  //       vendorOrgName1              : String;
  //       vendorQuote1                : String;
  //       vendorProcType1             : String; //dropdown Sources/ 2 quotes(Commodity/others)
  //       vendorOrgName2              : String;
  //       vendorQuote2                : String;
  //       vendorProcType2             : String; //dropdown
  //       vendorOrgName3              : String;
  //       vendorQuote3                : String;
  //       vendorProcType3             : String; //dropdown Sources /3 Quotes
  //       oemRef                      : String;
  //       quoteValid                  : String;
  //       repeatOrderNo               : String;
  //       singleSourceAppr            : String;
  //       initialQuoteRef             : String;
  //       initialQuoteDate            : String;
  //       initialQuoteVal             : String;
  //       vendorRep                   : String;
  //       finalQuoteRef               : String;
  //       finalQuoteDate              : String;
  //       finalQuoteValue             : String;
  //       deliveryWeek                : String;
  //       agreedPacking               : String;
  //       agreedTransport             : String;
  //       perDiscOffered              : String;
  //       agreedWarranty              : String;
  //       mailId                      : String;
  //       name                        : String;
  //       contactNo                   : String;
  //       address1                    : String;
  //       state                       : String;
  //       pinCode                     : String;
  //       accounts                    : String;
  //       vendorCode                  : String;
  //       finalizedVendCode           : String;
  //       vendorPinQuote              : String;
  //       vendorGstQuote              : String;
  //       selectAgent                 : String;
  //       remarks                     : String(1000);
  //       amendmentRem                : String;
  //       repeatOrderDate             : String;
  //       selectedReason              : String;
  //       vendorOrgName4              : String;
  //       vendorOrgName5              : String;
  //       vendorProcType4             : String;
  //       vendorProcType5             : String;
  //       singleQuote                 : String(500);
  //       vendorQuote4                : String;
  //       vendorQuote5                : String;
  //       arcSerialNo                 : String;
  //       confirmDate                 : String;
  //       orderFrom                   : String;
  //       amdVersion                  : String;
  //       provCleared                 : Boolean;
  //       documentClearance           : String;
  //       postClearedBy               : String;
  //       assetManagedBy              : String;
  //       poProcessedBy               : String;
  //       preCommitedType             : String;
  //       finalAccept                 : String;
  //       accountStage                : String;
  //       agreeChecked                : Boolean;
  //       userDeclarationApproved     : Boolean;
  //       approvedForSingleQuote      : Boolean;
  //       planConfirmation            : Boolean;
  //       requesterQuery              : String(1000);
  //       clarificationTask           : String(1020);
  //       requestedBy                 : String;
  //       servCorrectness             : Boolean;
  //       servCorrectness_rem         : String;
  //       specPartNumber              : Boolean;
  //       specPartNumber_rem          : String;
  //       monthMentioned              : Boolean;
  //       monthMentioned_rem          : String;
  //       unitRateAgreement           : Boolean;
  //       unitRateAgreement_rem       : String;
  //       freightItemMade             : Boolean;
  //       freightItemMade_rem         : String;
  //       repeatOrderMatch            : Boolean;
  //       repeatOrderMatch_rem        : String;
  //       vend1QuoteCorrect           : Boolean;
  //       vend1QuoteCorrect_rem       : String;
  //       vend2QuoteCorrect           : Boolean;
  //       vend2QuoteCorrect_rem       : String;
  //       vend3QuoteCorrect           : Boolean;
  //       vend3QuoteCorrect_rem       : String;
  //       drawings                    : Boolean;
  //       drawings_rem                : String;
  //       quotationMapping            : Boolean;
  //       quotationMapping_rem        : String;
  //       amcWorkSignedOff            : Boolean;
  //       amcWorkSignedOff_rem        : String;
  //       //Vendor1
  //       vendorName_ven1             : String;
  //       vendorOrganisationName_ven1 : String(100);
  //       initialQuoteReference_ven1  : String(100);
  //       initialQuoteDate_ven1       : Date;
  //       initialQuoteValue_ven1      : Decimal(10, 0);
  //       vendorRepresentative_ven1   : String(100);
  //       finalQuoteReference_ven1    : String(100);
  //       finalQuoteDate_ven1         : DateTime;
  //       finalQuoteValue_ven1        : Decimal(10, 0);
  //       deliveryWeek_ven1           : String(100);
  //       packingForwardingTerms_ven1 : String(50); // dropdown
  //       transportTerms_ven1         : String(50); // dropdown
  //       discountPercent_ven1        : Decimal(5, 2); // calculated on read
  //       warranty_ven1               : String(50); // dropdown
  //       procurementType_ven1        : String(50); // dropdown
  //       vendorEmail_ven1            : String(100);
  //       vendorCode_ven1             : String(20);
  //       //Vendor 2
  //       vendorName_ven2             : String;
  //       vendorOrganisationName_ven2 : String(100);
  //       initialQuoteReference_ven2  : String(100);
  //       initialQuoteDate_ven2       : Date;
  //       initialQuoteValue_ven2      : Decimal(10, 0);
  //       vendorRepresentative_ven2   : String(100);
  //       finalQuoteReference_ven2    : String(100);
  //       finalQuoteDate_ven2         : DateTime;
  //       finalQuoteValue_ven2        : Decimal(10, 0);
  //       deliveryWeek_ven2           : String(100);
  //       packingForwardingTerms_ven2 : String(50); // dropdown
  //       transportTerms_ven2         : String(50); // dropdown
  //       discountPercent_ven2        : Decimal(5, 2); // calculated on read
  //       warranty_ven2               : String(50); // dropdown
  //       procurementType_ven2        : String(50); // dropdown
  //       vendorEmail_ven2            : String(100);
  //       vendorCode_ven2             : String(20);
  //       typeOfWork                  : String;
  //       workArea                    : String;
  // }


  //new table for RP
  entity PurReqDtl {

    key PR_Num                      : String;
    key version                     : String;
        reason                      : String;
        reqID                       : String;
        department                  : String;
        createdBy                   : String;
        location                    : String;
        dated                       : String;
        plant                       : String;
        budgetCode                  : String;
        description                 : String;
        documentType                : String;
        totalValue                  : Decimal(15, 2);
        totalBudget                 : Decimal(15, 2);
        cumTentAmount               : Decimal(15, 2);
        cumRelAmount                : Decimal(15, 2);
        budgetBalance               : String;
        project                     : String;
        budgetValue                 : Decimal(15, 2);
        reqTokenNo                  : String;
        reqName                     : String;
        initiatorRem                : String(1000);
        selectedFlow                : String(5);
        otherSource                 : String;
        genRemark                   : String;
        sanctionBy                  : String;
        clearedBy                   : String;
        justNote                    : String(600);
        items                       : Composition of many PurReqLineItemsDtl
                                        on items.PR_Line = $self;
        quotationType               : String;
        fromDate                    : DateTime;
        toDate                      : DateTime;
        capexOpex                   : String;
        category                    : String;
        subCategory                 : String;
        sector                      : String;
        subSector                   : String;
        userContact                 : String;
        mrvDepartment               : String; //dropdown
        function                    : String;
        commodity                   : String; //dropdown
        descProcurement             : String(1020);
        protoAlliedServ             : String; //dropdown
        sources                     : String; //dropdown
        mrvBudget                   : String;
        natureOfExp                 : String;
        techSpecification           : String;
        delLocation                 : String(500); //dropdown
        specialCase                 : String(500);
        typePR                      : String; //dropdown
        stage1Rep                   : String;
        stage2Rep                   : String;
        recomVendor                 : String(500); //dropdown
        reasonRecom                 : String(1000);
        recomApprover1              : String;
        recomApprover2              : String;
        recomApprover3              : String;
        recomApprover4              : String;
        recomApprover5              : String;
        recomApprover6              : String;
        lowestVendor                : String;
        vendorOrgName               : String; //Sources/ ARC
        vendorProcType              : String;
        vendorOrgName1              : String;
        vendorQuote1                : String;
        vendorProcType1             : String; //dropdown Sources/ 2 quotes(Commodity/others)
        vendorOrgName2              : String;
        vendorQuote2                : String;
        vendorProcType2             : String; //dropdown
        vendorOrgName3              : String;
        vendorQuote3                : String;
        vendorProcType3             : String; //dropdown Sources /3 Quotes
        oemRef                      : String;
        quoteValid                  : String;
        repeatOrderNo               : String;
        singleSourceAppr            : String;
        initialQuoteRef             : String;
        initialQuoteDate            : String;
        initialQuoteVal             : String;
        vendorRep                   : String;
        finalQuoteRef               : String;
        finalQuoteDate              : String;
        finalQuoteValue             : String;
        deliveryWeek                : String;
        agreedPacking               : String;
        agreedTransport             : String;
        perDiscOffered              : String;
        agreedWarranty              : String;
        mailId                      : String;
        name                        : String;
        contactNo                   : String;
        address1                    : String;
        state                       : String;
        pinCode                     : String;
        accounts                    : String;
        vendorCode                  : String;
        finalizedVendCode           : String;
        vendorPinQuote              : String;
        vendorGstQuote              : String;
        selectAgent                 : String;
        remarks                     : String(1000);
        amendmentRem                : String;
        repeatOrderDate             : String;
        selectedReason              : String;
        vendorOrgName4              : String;
        vendorOrgName5              : String;
        vendorProcType4             : String;
        vendorProcType5             : String;
        singleQuote                 : String(500);
        vendorQuote4                : String;
        vendorQuote5                : String;
        arcSerialNo                 : String;
        confirmDate                 : String;
        orderFrom                   : String;
        amdVersion                  : String;
        provCleared                 : Boolean;
        documentClearance           : String;
        postClearedBy               : String;
        assetManagedBy              : String;
        poProcessedBy               : String;
        preCommitedType             : String;
        finalAccept                 : String;
        accountStage                : String;
        agreeChecked                : Boolean;
        userDeclarationApproved     : Boolean;
        approvedForSingleQuote      : Boolean;
        planConfirmation            : Boolean;
        requesterQuery              : String(1000);
        clarificationTask           : String(1020);
        requestedBy                 : String;
        servCorrectness             : Boolean;
        servCorrectness_rem         : String;
        specPartNumber              : Boolean;
        specPartNumber_rem          : String;
        monthMentioned              : Boolean;
        monthMentioned_rem          : String;
        unitRateAgreement           : Boolean;
        unitRateAgreement_rem       : String;
        freightItemMade             : Boolean;
        freightItemMade_rem         : String;
        repeatOrderMatch            : Boolean;
        repeatOrderMatch_rem        : String;
        vend1QuoteCorrect           : Boolean;
        vend1QuoteCorrect_rem       : String;
        vend2QuoteCorrect           : Boolean;
        vend2QuoteCorrect_rem       : String;
        vend3QuoteCorrect           : Boolean;
        vend3QuoteCorrect_rem       : String;
        drawings                    : Boolean;
        drawings_rem                : String;
        quotationMapping            : Boolean;
        quotationMapping_rem        : String;
        amcWorkSignedOff            : Boolean;
        amcWorkSignedOff_rem        : String;
        //Vendor1
        vendorName_ven1             : String;
        vendorOrganisationName_ven1 : String(100);
        initialQuoteReference_ven1  : String(100);
        initialQuoteDate_ven1       : Date;
        initialQuoteValue_ven1      : Decimal(10, 0);
        vendorRepresentative_ven1   : String(100);
        finalQuoteReference_ven1    : String(100);
        finalQuoteDate_ven1         : DateTime;
        finalQuoteValue_ven1        : Decimal(10, 0);
        deliveryWeek_ven1           : String(100);
        packingForwardingTerms_ven1 : String(50); // dropdown
        transportTerms_ven1         : String(50); // dropdown
        discountPercent_ven1        : Decimal(5, 2); // calculated on read
        warranty_ven1               : String(50); // dropdown
        procurementType_ven1        : String(50); // dropdown
        vendorEmail_ven1            : String(100);
        vendorCode_ven1             : String(20);
        //Vendor 2
        vendorName_ven2             : String;
        vendorOrganisationName_ven2 : String(100);
        initialQuoteReference_ven2  : String(100);
        initialQuoteDate_ven2       : Date;
        initialQuoteValue_ven2      : Decimal(10, 0);
        vendorRepresentative_ven2   : String(100);
        finalQuoteReference_ven2    : String(100);
        finalQuoteDate_ven2         : DateTime;
        finalQuoteValue_ven2        : Decimal(10, 0);
        deliveryWeek_ven2           : String(100);
        packingForwardingTerms_ven2 : String(50); // dropdown
        transportTerms_ven2         : String(50); // dropdown
        discountPercent_ven2        : Decimal(5, 2); // calculated on read
        warranty_ven2               : String(50); // dropdown
        procurementType_ven2        : String(50); // dropdown
        vendorEmail_ven2            : String(100);
        vendorCode_ven2             : String(20);
        typeOfWork                  : String;
        workArea                    : String;
        Hazardous                   : String
  }


  //PR Child table for line items and value details
  //Change entity name and association as well
  // entity PurReqLineItems {
  //   key ID              : String;
  //       PR_Line         : Association to PurReqDetail;
  //       SN              : String;
  //       itemNo          : String;
  //       itemDescription : String;
  //       quantity        : Integer;
  //       UorM            : String;
  //       rateInr         : Decimal(15, 2);
  //       totalVal        : Decimal(15, 2);
  //       glCode          : String;
  //       plant           : String;
  //       WBSCode         : String;
  //       itemCat         : String;
  //       natureOfAct     : String;
  // }


  // new table for RP
  entity PurReqLineItemsDtl {
    key ID              : String;
        PR_Line         : Association to PurReqDtl;
        SN              : String;
        itemNo          : String;
        itemDescription : String;
        quantity        : Integer;
        UorM            : String;
        rateInr         : Decimal(15, 2);
        totalVal        : Decimal(15, 2);
        glCode          : String;
        plant           : String;
        WBSCode         : String;
        itemCat         : String;
        natureOfAct     : String;
  }

  // entity PurReqVendor : cuid {
  //   PR_Vendor              : Association to PurReqDetail;
  //   vendorName             : String;
  //   vendorOrganisationName : String(100);
  //   initialQuoteReference  : String(100);
  //   initialQuoteDate       : Date;
  //   initialQuoteValue      : Decimal(10, 0);
  //   vendorRepresentative   : String(100);
  //   finalQuoteReference    : String(100);
  //   finalQuoteDate         : DateTime;
  //   finalQuoteValue        : Decimal(10, 0);
  //   deliveryWeek           : String(100);
  //   packingForwardingTerms : String(50); // dropdown
  //   transportTerms         : String(50); // dropdown
  //   discountPercent        : Decimal(5, 2); // calculated on read
  //   warranty               : String(50); // dropdown
  //   procurementType        : String(50); // dropdown
  //   vendorEmail            : String(100);
  //   vendorCode             : String(20);
  // }

  // entity PurReqCheckpoints : cuid {
  //   PR_Check    : Association to PurReqDetail;
  //   description : String; // e.g. "Service / Supply - SAC / HSN Correctness"
  //   status      : String; // e.g. Ok, Not Ok, NA
  //   remarks     : String;

  // }


  entity ExpenseReport as
    select from Request
    left outer join ReqFormEXP
      on ReqFormEXP.reqID = Request.reqID
    {
      key Request.reqID,
          Request.type,
          Request.refNo,
          Request.status,
          Request.createdAt,
          Request.modifiedAt,
          Request.modifiedBy,
          Request.createdBy,
          Request.createdByDtl,
          Request.pendingWithName,
          Request.pendingWith,
          ReqFormEXP.quotationAmount,
          ReqFormEXP.approvalAmount,
          ReqFormEXP.manager,
          ReqFormEXP.location,
          ReqFormEXP.costCenter,
          ReqFormEXP.WBSCode,
          ReqFormEXP.purpose
    }


  // pdf images and logo
  @cds.server.body_parser.limit: '10mb'
  entity imgLogo : cuid {
    type      : String;
    identity  : String;

    @Core.ContentDisposition.Filename: fileName
    @Core.MediaType                  : mediaType
    content   : LargeBinary;

    @Core.IsMediaType: true
    mediaType : String;
    fileName  : String;
  }



//  new entity 
 entity volumeBreakup: cuid{
    reqID : String;
    rowNo : Integer;
    columnNo : Integer;
    cellValue : String;
    columnValue : String;
  }
 

}
