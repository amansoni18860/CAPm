namespace employee.db;

using {
    ContactInfo,
    AddressInfo
} from './commons';
using {
    cuid,
    managed
} from '@sap/cds/common';
using {department.db as Department} from './department';
using {leave.db as Leave} from './leaves';
using {payroll.db as Payroll} from './payroll';
using {project.db as Project} from './projects';


type Designation : String(30) enum {

    INTERN = 'Intern';

    TRAINEE = 'Trainee';

    ASSOCIATE_ENG = 'Associate Engineer';

    ENGINEER = 'Engineer';

    SENIOR_ENG = 'Senior Engineer';

    TECH_LEAD = 'Technical Lead';

    TEAM_LEAD = 'Team Lead';

    ARCHITECT = 'Architect';

    MANAGER = 'Manager';

    SENIOR_MANAGER = 'Senior Manager';

    DELIVERY_MANAGER = 'Delivery Manager';

    ASSOCIATE_DIR = 'Associate Director';

    DIRECTOR = 'Director';

    VP = 'Vice President';

    CTO = 'Chief Technology Officer';
}

entity Genders {
    key code : String(10);
        text : String(20);

}

entity EmergencyContacts : cuid {
    parent       : Association to Employee;
    contactName  : localized String(20);
    relationship : localized String(20);
    phone        : String(15);
}


entity Educations : cuid {
    parent     : Association to Employee;
    degree     : localized String(50);
    institute  : localized String(80);
    percentage : Decimal(5, 2);
    yearPassed : Integer;
}

entity Employee : cuid, managed, AddressInfo, ContactInfo {

    name                           : localized String(30) not null;

    virtual fullName               : String(100);
    virtual avatarUrl              : String(100)    @Core.Computed;

    photoUrl                       : String(500);
    employeeCode                   : String(30)     @readonly;

    age                            : Integer        @mandatory;
    gender                         : Association to one Genders not null;
    designation                    : Designation not null;
    joiningDate                    : Timestamp;

    salary                         : Decimal(15, 2) @readonly;

    virtual bonusFieldControl      : Integer        @Core.Computed;

    virtual canPromote             : Boolean        @Core.Computed;
    virtual canTransferDepartment  : Boolean        @Core.Computed;
    virtual canAssignManager       : Boolean        @Core.Computed;

    virtual canEditEmployee        : Boolean        @Core.Computed;
    virtual canDeleteEmployee      : Boolean        @Core.Computed;


    virtual canApproveLeave        : Boolean;
    virtual canRejectLeave         : Boolean;
    virtual canCancelLeave         : Boolean;

    currency                       : String(3) default 'INR';

    bonus                          : Decimal(15, 2);
    totalSalary                    : Decimal(15, 2) = salary + bonus;


    password                       : String         @Core.Computed;
    virtual designationCriticality : Integer;


    manager                        : Association to one Employee;
    department                     : Association to one Department.Departments;

    leaves                         : Association to many Leave.Leaves
                                         on leaves.employee = $self;

    payrolls                       : Association to many Payroll.Payrolls
                                         on payrolls.employee = $self;

    managedProjects                : Association to many Project.Projects
                                         on managedProjects.projectManager = $self;

    reportees                      : Association to many Employee
                                         on reportees.manager = $self;

    contacts                       : Composition of many EmergencyContacts
                                         on contacts.parent = $self;


    educations                     : Composition of many Educations
                                         on educations.parent = $self;
}
