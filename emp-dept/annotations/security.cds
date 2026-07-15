using capmService from '../srv/service';


annotate capmService.Employees with @(restrict : [

    {
        grant : '*',
        to    : 'Admin'
    },

    {
        grant : 'READ',
        to    : ['HRManager', 'DepartmentManager', 'Employee', 'Viewer']
    },

    {
        grant : ['READ','UPDATE'],
        to : ['Employee']

    },

    {
        grant : ['CREATE', 'UPDATE', 'DELETE'],
        to    : 'HRManager'
    }

]);




annotate capmService.Employees actions {

    promote @(restrict : [
        {
            grant : 'EXECUTE',
            to    : ['Admin', 'HRManager']
        }
    ]);

    transferDepartment @(restrict : [
        {
            grant : 'EXECUTE',
            to    : ['Admin', 'HRManager']
        }
    ]);

    assignManager @(restrict : [
        {
            grant : 'EXECUTE',
            to    : ['Admin', 'HRManager']
        }
    ]);

};



annotate capmService.Departments with @(restrict : [

    {
        grant : '*',
        to    : 'Admin'
    },

    {
        grant : 'READ',
        to    : ['HRManager', 'DepartmentManager', 'Employee', 'Viewer']
    },

    {
        grant : ['UPDATE'],
        to    : ['DepartmentManager']
    }

]);




annotate capmService.Departments actions {

    allocateBudget @(restrict : [
        {
            grant : 'EXECUTE',
            to    : ['Admin', 'DepartmentManager']
        }
    ]);

};




annotate capmService.Projects with @(restrict : [

    {
        grant : '*',
        to    : 'Admin'
    },

    {
        grant : 'READ',
        to    : ['HRManager', 'DepartmentManager', 'Employee', 'Viewer']
    },

    {
        grant : ['CREATE', 'UPDATE', 'DELETE'],
        to    : ['DepartmentManager']
    }

]);



annotate capmService.Projects actions {

    closeProject @(restrict : [
        {
            grant : 'EXECUTE',
            to    : ['Admin', 'DepartmentManager']
        }
    ]);

    changeManager @(restrict : [
        {
            grant : 'EXECUTE',
            to    : ['Admin', 'DepartmentManager']
        }
    ]);

};




annotate capmService.Leaves with @(restrict : [

    {
        grant : '*',
        to    : 'Admin'
    },

    {
        grant : ['READ', 'CREATE'],
        to    : ['Employee', 'HRManager']
    },

    {
        grant : ['UPDATE'],
        to    : ['HRManager']
    }

]);



annotate capmService.Assets with @(restrict : [

    {
        grant : '*',
        to    : 'Admin'
    },

    {
        grant : 'READ',
        to    : ['Employee', 'HRManager', 'DepartmentManager']
    },

    {
        grant : ['CREATE', 'UPDATE', 'DELETE'],
        to    : ['HRManager']
    }

]);


annotate capmService.generateMonthlyPayroll with @(restrict : [
    {
        grant : 'EXECUTE',
        to    : ['Admin', 'HRManager']
    }
]);



annotate capmService.approveLeave with @(restrict : [
    {
        grant : 'EXECUTE',
        to    : ['Admin', 'HRManager']
    }
]);

annotate capmService.assignAsset with @(restrict : [
    {
        grant : 'EXECUTE',
        to    : ['Admin', 'HRManager']
    }
]);



annotate capmService.getDashboardSummary with @(restrict : [
    {
        grant : 'EXECUTE',
        to    : ['Admin', 'HRManager']
    }
]);

annotate capmService.getEmployeeCount with @(restrict : [
    {
        grant : 'EXECUTE',
        to    : ['Admin', 'HRManager']
    }
]);












