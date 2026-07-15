using capmService from '../srv/service';

annotate capmService.Employees with @(UI.LineItem: [

    {
        Value: photoUrl,
        Label: 'Photo'
    },
    {
        Value     : name,
        Importance: #High
    },

    {
        Value     : employeeCode,
        Importance: #High
    },

    {
        Value     : designation,
        Criticality : designationCriticality,
        Importance: #High
    },

  {
        Value     : gender.text,
        Label     : 'Gender',
        Importance: #High
    },

    {
        Value     : age,
        Importance: #High
    },

    {
        Value     : salary,
        Importance: #High
    },

    {
        Value     : city,
        Importance: #Medium
    },

    {
        Value     : email,
        Importance: #Medium
    }

]);




annotate capmService.EmergencyContacts with @(
    UI.LineItem : [
        { Label : 'Contact Name', Value : contactName },
        { Label : 'Relationship', Value : relationship },
        { Label : 'Phone', Value : phone }
    ]
);




annotate capmService.Educations with @(
    UI.LineItem : [

        {
            Value : degree,
            Label : 'Degree'
        },

        {
            Value : institute,
            Label : 'Institute'
        },

        {
            Value : percentage,
            Label : 'Percentage'
        },

        {
            Value : yearPassed,
            Label : 'Year Passed'
        }

    ]
);