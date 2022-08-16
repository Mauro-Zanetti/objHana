using {bookshelf as my} from '../db/schema';
using {V_INTERACTION as myv} from '../db/schema';

service CatalogService {
    entity Interactions_Header as projection on my.Interactions_Header;
    entity Interactions_Items  as projection on my.Interactions_Items;
    entity Books               as projection on my.Books;
    entity Authors             as projection on my.Authors;
    entity V_Interaction       as projection on myv;
}

// hay comentarios con explicaciones en db/schema.cds