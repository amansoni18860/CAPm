using { bookscapm.db.Book, bookscapm.db.Library } from '../db/schema';

service LibraryService {

    entity Books as projection on Book;

    entity Libraries as projection on Library;

}