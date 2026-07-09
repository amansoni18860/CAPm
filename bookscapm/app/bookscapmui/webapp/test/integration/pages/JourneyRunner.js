sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"bookscapmui/test/integration/pages/BooksList",
	"bookscapmui/test/integration/pages/BooksObjectPage"
], function (JourneyRunner, BooksList, BooksObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('bookscapmui') + '/test/flpSandbox.html#bookscapmui-tile',
        pages: {
			onTheBooksList: BooksList,
			onTheBooksObjectPage: BooksObjectPage
        },
        async: true
    });

    return runner;
});

