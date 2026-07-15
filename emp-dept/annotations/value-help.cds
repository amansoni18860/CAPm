using capmService from '../srv/service';

annotate capmService.Employees with {

    department @Common.Text : department.name;

    department @Common.ValueList : {
        Label : 'Department',
        CollectionPath : 'Departments',

        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : department_ID,
                ValueListProperty : 'ID'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }
        ]
    };

};

annotate capmService.Employees with {

    gender @Common.ValueList : {
        Label : 'Gender',
        CollectionPath : 'Genders',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : gender_code,
                ValueListProperty : 'code'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'text'
            }
        ]
    };

    gender @Common.Text : gender.text;
    gender @Common.TextArrangement : #TextOnly;
};

annotate capmService.Employees with {

    manager @Common.Text : manager.name;
    manager @Common.TextArrangement : #TextOnly;

    manager @Common.ValueList : {
        Label : 'Manager',
        CollectionPath : 'Employees',

        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : manager_ID,
                ValueListProperty : 'ID'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }
        ]
    };

};




annotate capmService.Projects with {

    projectManager @Common.Text : projectManager.name;
    projectManager @Common.TextArrangement : #TextOnly;

    projectManager @Common.ValueList : {
        Label : 'Project Manager',
        CollectionPath : 'Employees',

        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : projectManager_ID,
                ValueListProperty : 'ID'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }
        ]
    };

};





annotate capmService.Assets with {

    assignedTo @Common.Text : assignedTo.name;
    assignedTo @Common.TextArrangement : #TextOnly;

    assignedTo @Common.ValueList : {
        Label : 'Assigned Employee',
        CollectionPath : 'Employees',

        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : assignedTo_ID,
                ValueListProperty : 'ID'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }
        ]
    };

};






annotate capmService.Leaves with {

    employee @Common.Text : employee.name;
    employee @Common.TextArrangement : #TextOnly;

    employee @Common.ValueList : {
        Label : 'Employee',
        CollectionPath : 'Employees',

        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : employee_ID,
                ValueListProperty : 'ID'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }
        ]
    };

};




annotate capmService.Payrolls with {

    employee @Common.Text : employee.name;
    employee @Common.TextArrangement : #TextOnly;

    employee @Common.ValueList : {
        Label : 'Employee',
        CollectionPath : 'Employees',

        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : employee_ID,
                ValueListProperty : 'ID'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }
        ]
    };

};