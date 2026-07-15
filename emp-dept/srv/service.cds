using {employee.db as emp} from '../db/employee';
using {asset.db as ast} from '../db/assets';
using {department.db as dept} from '../db/department';
using {leave.db as lev} from '../db/leaves';
using {payroll.db as pay} from '../db/payroll';
using {project.db as proj} from '../db/projects';
using from '../annotations/annotations';

service capmService {


   entity Genders     as projection on emp.Genders;

   // ------------------------------------------------------------------
   // Custom Types
   // ------------------------------------------------------------------

   type SalaryBreakup {
      basic       : Decimal(15, 2);
      bonus       : Decimal(15, 2);
      totalSalary : Decimal(15, 2);
   }

   type DashboardSummary {
      employeeCount   : Integer;
      projectCount    : Integer;
      departmentCount : Integer;
   }

   // ------------------------------------------------------------------
   // Employees
   // ------------------------------------------------------------------

   @odata.draft.enabled
   entity Employees   as projection on emp.Employee
      actions {

         // Bound Functions

         function getAnnualSalary()                        returns Decimal(15, 2);

         function getTeamSize()                            returns Integer;

         function getManager()                             returns Employees;

         function getSalaryBreakup()                       returns SalaryBreakup;

         // Bound Actions

         action   promote(newDesignation: emp.Designation) returns String;

         action   transferDepartment(departmentId: UUID)   returns String;

         action   assignManager(managerId: UUID)           returns String;
      };

   // ------------------------------------------------------------------
   // Departments
   // ------------------------------------------------------------------

   entity Departments as projection on dept.Departments
      actions {

         function getEmployeeCount()                     returns Integer;

         action   allocateBudget(amount: Decimal(15, 2)) returns String;
      };

   // ------------------------------------------------------------------
   // Projects
   // ------------------------------------------------------------------

   entity Projects    as projection on proj.Projects
      actions {

         function getProjectCost()               returns Decimal(15, 2);

         action   closeProject()                 returns String;

         action   changeManager(managerId: UUID) returns String;
      };

   // ------------------------------------------------------------------
   // Other Entities
   // ------------------------------------------------------------------

   entity Assets      as projection on ast.Assets;
   entity Leaves      as projection on lev.Leaves;
   entity Payrolls    as projection on pay.Payrolls;

   // ------------------------------------------------------------------
   // Unbound Functions
   // ------------------------------------------------------------------

   function getEmployeeCount()                          returns Integer;

   function getDepartmentCount()                        returns Integer;

   function getActiveProjectCount()                     returns Integer;

   function getTotalPayrollCost()                       returns Decimal(15, 2);

   function getDashboardSummary()                       returns DashboardSummary;

   function getTopEmployees()                           returns array of Employees;

   function getProjectsByDepartment(departmentId: UUID) returns array of Projects;

   // ------------------------------------------------------------------
   // Unbound Actions
   // ------------------------------------------------------------------

   action   generateMonthlyPayroll(month: String,
                                   year: Integer)       returns String;

   action   closeProject(projectId: UUID)               returns String;

   action   approveLeave(leaveId: UUID)                 returns String;

   action   assignAsset(employeeId: UUID,
                        assetId: UUID)                  returns String;
}
