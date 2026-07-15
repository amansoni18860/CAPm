namespace project.db;

using { cuid, managed, temporal } from '@sap/cds/common';
using { employee.db as Employee } from './employee';
using { department.db as Department } from './department';

type ProjectStatus : String enum {
    PLANNING    = 'Planning';
    ACTIVE      = 'Active';
    ON_HOLD     = 'On Hold';
    COMPLETED   = 'Completed';
    CANCELLED   = 'Cancelled';
}

type ProjectType : String enum {
    INTERNAL    = 'Internal';
    CLIENT      = 'Client';
    RESEARCH    = 'Research';
    MAINTENANCE = 'Maintenance';
}

entity Projects : cuid, managed, temporal {

    projectCode      : String(20) not null;
    projectName      : localized String(100) not null;

    projectType      : ProjectType not null;
    status           : ProjectStatus not null;

    projectManager   : Association to one Employee.Employee;
    department       : Association to one Department.Departments;

    budget           : Decimal(15,2);
    cost             : Decimal(15,2);

    teamSize         : Integer default 0;

    clientName       : localized String(100);

    description      : localized String(500);
}