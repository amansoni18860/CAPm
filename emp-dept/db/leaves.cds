namespace leave.db;

using { cuid, managed } from '@sap/cds/common';
using { employee.db as Employee } from './employee';

type LeaveType : String enum {
    CASUAL      = 'Casual Leave';
    SICK        = 'Sick Leave';
    EARNED      = 'Earned Leave';
    MATERNITY   = 'Maternity Leave';
    PATERNITY   = 'Paternity Leave';
    UNPAID      = 'Unpaid Leave';
}

type LeaveStatus : String enum {
    PENDING     = 'Pending';
    APPROVED    = 'Approved';
    REJECTED    = 'Rejected';
    CANCELLED   = 'Cancelled';
}

entity Leaves : cuid, managed {

    employee    : Association to one Employee.Employee not null;
    leaveType   : LeaveType not null;
    startDate   : Date not null;
    endDate     : Date not null;
    totalDays   : Integer not null;
    reason      : localized String(500);
    appliedOn   : Date;
    approvedBy  : Association to one Employee.Employee;
    status      : LeaveStatus default 'PENDING';
    approvals : Composition of many LeaveApprovals on approvals.leave = $self;
}


entity LeaveApprovals : cuid {
leave : Association to Leaves;
action : localized String(20);
remarks : localized String(250);
actionDate : Timestamp;
}