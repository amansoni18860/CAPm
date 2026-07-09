namespace bookscapm.db;

type BooksAgeGroup : String enum {
    Children;
    YoungAdult;
    Adult;
}

entity Book {
    key ID            : UUID;
    Title             : String(100);
    Author            : String(100);
    PublishedDate     : DateTime;
    Price             : Decimal(10,2);
    isAvailable       : Boolean;
    booksAgeGroup     : BooksAgeGroup;
}

entity Library {
    key ID            : UUID;
    totalBooks        : Integer;
}