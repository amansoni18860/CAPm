using capmService from '../srv/service';

annotate capmService.Employees with {

    name          @Search.defaultSearchElement     @Common.Label: 'Employee Name';
    employeeCode  @Search.defaultSearchElement     @Common.Label: 'Employee Code';
    age           @Common.Label          : 'Age';
    gender        @Common.Label          : 'Gender';
    designation   @Search.defaultSearchElement     @Common.Label: 'Designation';
    joiningDate   @UI.HiddenFilter                 @Common.Label: 'Joining Date';

    salary        @Measures.ISOCurrency: currency  @Common.Label: 'Salary';

   bonus @Measures.ISOCurrency : currency
      @Common.Label         : 'Bonus'
      @Common.FieldControl  : bonusFieldControl;

    totalSalary   @Measures.ISOCurrency: currency  @Common.Label: 'Total Compensation';


    phone         @Common.Label          : 'Phone Number';
    email         @Common.Label          : 'Email Address';

    city          @Common.Label          : 'City';
    state         @Common.Label          : 'State';
    country       @Common.Label          : 'Country';
    department    @Common.Label          : 'Department';

    photoUrl      @UI.HiddenFilter                 @UI.IsImageURL;


    department    @Common.TextArrangement: #TextOnly;


    password      @UI.Hidden;






};


annotate capmService.EmergencyContacts with {

    contactName  @Common.Label: 'Contact Name';
    relationship @Common.Label: 'Relationship';
    phone        @Common.Label: 'Phone Number';

};


annotate capmService.Educations with {

    degree     @Common.Label: 'Degree';
    institute  @Common.Label: 'Institute';
    percentage @Common.Label: 'Percentage';
    yearPassed @Common.Label: 'Year Passed';

};


annotate capmService.Employees with @Common.SideEffects #RefreshEmployee: {

    SourceProperties: [
        manager_ID,
        department_ID,
        gender_code,
        designation
    ],

    TargetEntities  : ['']

};


annotate capmService.Employees with actions {

    promote            @Common.SideEffects: {TargetEntities: ['']};
    transferDepartment @Common.SideEffects: {TargetEntities: ['']};
    assignManager      @Common.SideEffects: {TargetEntities: ['']};

};


annotate capmService.Employees with @(


    // UI.CreateHidden : true,
    // UI.UpdateHidden : true,
    // UI.DeleteHidden : true,


    Search.Searchable                 : true,


    UI.HeaderInfo                     : {
        TypeName      : 'Employee',
        TypeNamePlural: 'Employees',

        Title         : {Value: name},

        Description   : {Value: employeeCode},

        ImageUrl      : photoUrl,
        TypeImageUrl  : 'sap-icon://employee'
    },

    UI.FieldGroup #JobInfo            : {


    Data: [

        {Value: designation},

        {
            Value: department.name,
            Label: 'Department'
        },

        {
            Value: manager.name,
            Label: 'Reporting Manager'
        }

    ]},

    UI.FieldGroup #ContactInfo        : {Data: [
        {Value: email},
        {Value: phone}
    ]},

    UI.DataPoint #Salary              : {
        Title: 'Salary',
        Value: salary
    },

    UI.DataPoint #Bonus               : {
        Title: 'Bonus',
        Value: bonus
    },

    UI.DataPoint #TotalCompensation   : {
        Title: 'Total Compensation',
        Value: totalSalary
    },

    UI.HeaderFacets                   : [

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Job Information',
            Target: '@UI.FieldGroup#JobInfo'
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Contact Information',
            Target: '@UI.FieldGroup#ContactInfo'
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Salary',
            Target: '@UI.DataPoint#Salary'
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Total Compensation',
            Target: '@UI.DataPoint#TotalCompensation'
        }

    ],

    UI.SelectionFields                : [
        employeeCode,
        name,
        designation,
        gender_code,
        department_ID,
        joiningDate
    ],

    UI.FieldGroup #GeneralInfoSection : {

    Data: [

        {Value: employeeCode},

        {Value: name},

        {Value: age},

        {
            Value: gender_code,
            Label: 'Gender'
        },

        {Value: joiningDate},
        {
            Label: 'Password',
            Value: password
        },


        {Value:salary, Label: 'Salary Field Control'},

    ]

    },

    UI.FieldGroup #AddressInfoSection : {

    Data: [

        {Value: city},

        {Value: state},

        {Value: country}

    ]

    },

    UI.FieldGroup #ContactInfoSection : {

    Data: [

        {Value: email},

        {Value: phone}

    ]

    },

    UI.FieldGroup #CompensationSection: {

    Data: [

        {Value: salary},

        {Value: bonus},

        {Value: totalSalary}

    ]

    },

    UI.Facets                         : [

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneralInfoSection'
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Address Information',
            Target: '@UI.FieldGroup#AddressInfoSection'
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Contact Information',
            Target: '@UI.FieldGroup#ContactInfoSection'
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Salary Information',
            Target: '@UI.FieldGroup#CompensationSection'
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Emergency Contacts',
            Target: 'contacts/@UI.LineItem'
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Education Details',
            Target: 'educations/@UI.LineItem'
        }

    ],

    UI.Identification                 : [

        {
            $Type : 'UI.DataFieldForAction',
            Action: 'capmService.promote',
            Label : 'Promote Employee'
        },

        {
            $Type : 'UI.DataFieldForAction',
            Action: 'capmService.transferDepartment',
            Label : 'Transfer Department'
        },

        {
            $Type : 'UI.DataFieldForAction',
            Action: 'capmService.assignManager',
            Label : 'Assign Manager'
        }

    ]

);
