sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"capm/employee/employeeui/test/integration/pages/EmployeesList.gen",
	"capm/employee/employeeui/test/integration/pages/EmployeesObjectPage.gen"
], function (JourneyRunner, EmployeesListGenerated, EmployeesObjectPageGenerated) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('capm/employee/employeeui') + '/test/flpSandbox.html#capmemployeeemployeeui-tile',
        pages: {
			onTheEmployeesListGenerated: EmployeesListGenerated,
			onTheEmployeesObjectPageGenerated: EmployeesObjectPageGenerated
        },
        async: true
    });

    return runner;
});

