using capmService from '../srv/service';

annotate capmService.Employees with actions {

    promote
        @Core.OperationAvailable : canPromote;

    transferDepartment
        @Core.OperationAvailable : canTransferDepartment;

    assignManager
        @Core.OperationAvailable : canAssignManager;

};