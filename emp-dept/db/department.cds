namespace department.db;

using {
    ContactInfo,
    AddressInfo
} from './commons';
using {
    cuid,
    managed
} from '@sap/cds/common';
using {employee.db as Employee} from './employee';
using {project.db as Project} from './projects';

type DepartmentName : String enum {
    HR = 'Human Resources';
    IT = 'Information Technology';
    FINANCE = 'Finance';
    SALES = 'Sales';
    MARKETING = 'Marketing';
    OPERATIONS = 'Operations';
    PROCUREMENT = 'Procurement';
    LEGAL = 'Legal';
    RND = 'Research and Development';
    SUPPORT = 'Customer Support';
}

entity Departments : cuid, managed, AddressInfo, ContactInfo {

    name            : DepartmentName not null @mandatory;

    headEmployee    : Association to one Employee.Employee;

    totalEmployees  : Integer default 0;
    totalProjects   : Integer default 0;

    budget          : Decimal(15, 2);

    establishedDate : Date;

    employees       : Association to many Employee.Employee
                          on employees.department = $self;


    projects        : Association to many Project.Projects
                          on projects.department = $self;
}


