using {cuid} from '@sap/cds/common';

namespace mm_dpde_master;

context master {
   @odata.draft.enabled
   entity Requester {
    @Common.Label : 'ID'
  key ID                   : String;
      requesterTokenNumber : String;
      department           : String;
      name                 : String;
      email                : String;
}

//TODO : camelCase //ADPD
entity Platform : cuid {
  platformId   : String; //changed
  platformDesc : String; //changed
  role         : String; //changed
  userId       : String //changed
}


entity ControlValues {
  key ID          : String; //TODO : camelCase : Id
      category    : String; // e.g., TransferType, NatureOfExpense, Forum, etc.
      description : String;
      location    : String;
}

  @odata.draft.enabled
  entity Approvers {
    @Common.Label : 'ID'
  key ID         : String; //TODO : camelCase ID : can make key among fields
      userID     : String; //employee id
      name       : String;
      email      : String;
      department : String; // Fina
      role       : String; // BuyerRequester, BuyerHOD, etc.
}

//TODO : camelCase
entity ApprovalDetermination : cuid {
  processId       : String;
  subProcessId    : String;
  condStringValue : String;
  condRangeMin    : Integer;
  operatorMin     : String;
  condRangeMax    : Integer;
  operatorMax     : String;
  condUnit        : String;
  approverRole    : String;
}


entity ProcessGroupTask {
  key ID        : String; //TODO : camelCase: ID
      processId : String; //SSFD, ADPD,NAB etc
      // subProcessId : String; //Newreq,CostOverrun, etc
      stage     : String;
      isGroup   : Boolean;
}

//used in Infra Service
entity PartDetails : cuid {
  key ID         : String; //TODO : camelCase:ID
      department : String;
      partNo     : String;
      partDesc   : String;
      binNo      : String;
      price      : String;
      UOM        : String;
}

}
