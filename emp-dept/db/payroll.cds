namespace payroll.db;

using { cuid, managed } from '@sap/cds/common';
using { employee.db as Employee } from './employee';

type PayrollStatus : String enum {
    DRAFT      = 'Draft';
    PROCESSED  = 'Processed';
    APPROVED   = 'Approved';
    PAID       = 'Paid';
    REJECTED   = 'Rejected';
}

type Month : String enum {
    JAN = 'January';
    FEB = 'February';
    MAR = 'March';
    APR = 'April';
    MAY = 'May';
    JUN = 'June';
    JUL = 'July';
    AUG = 'August';
    SEP = 'September';
    OCT = 'October';
    NOV = 'November';
    DEC = 'December';
}

entity Payrolls : cuid, managed {

    employee        : Association to one Employee.Employee not null;

    payrollYear     : Integer not null;
    payrollMonth    : Month not null;

    basicSalary     : Decimal(15,2) not null;
    hra             : Decimal(15,2) default 0;
    allowances      : Decimal(15,2) default 0;
    bonus           : Decimal(15,2) default 0;

    deductions      : Decimal(15,2) default 0;
    tax             : Decimal(15,2) default 0;

    grossSalary     : Decimal(15,2);
    netSalary       : Decimal(15,2);

    paymentDate     : Date;
    status          : PayrollStatus default 'DRAFT';

    components : Composition of many PayrollComponents on components.payroll = $self;
}



entity PayrollComponents : cuid {
payroll : Association to Payrolls;
componentName : localized String(50);
amount : Decimal(15,2);
}