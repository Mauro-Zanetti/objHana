// namespace ...;

using {Country} from '@sap/cds/common';

context bookshelf {

    // tipos y entidades creadas en este cds

    type BusinessKey : String(10);
    type SDate : DateTime;
    type LText : String(1024);

    entity Interactions_Header {
        key ID        : Integer;
            ITEMS     : Composition of many Interactions_Items
                            on ITEMS.INTHeader = $self;
            PARTNER   : BusinessKey;
            LOG_DATE  : SDate;
            BPCOUNTRY : Country;

    };

    entity Interactions_Items {
        key INTHeader : Association to Interactions_Header;
        key TEXT_ID   : BusinessKey;
            LANGU     : String(2);
            LOGTEXT   : LText;
    };

    // para usar estos hana objects hay que conectarse a hana cloud, hay un tutorial para ello en el teams
    // CIO SAP Program - BTP... > Files > Iniciativas - Investigaciones / Calculation View / doc
    // o en este tutorial https://developers.sap.com/tutorials/hana-cloud-cap-calc-view.html

    // para que se haga el deploy de los hana obj deben estar dentro de la carpeta db/src/
    // si no, son ignorados

    // usa la view de src/Books.hdbview que a su vez usa la tabla en Books.hdbtable
    @cds.persistence.exists
    entity Books {
        key id        : Integer;
            the_title : String(100);
    }

    // usa la tabla de src/Authors.hdbtable
    @cds.persistence.exists
    entity Authors {
        key id   : Integer;
            name : String(100);
    }
}


// Para crear una Calculation View: View > Find Command > SAP HANA: Create SAP HANA Database Artifact
// (Con esta comando en realidad se puede hacer cualquier objeto hana)

// Para ver como escribirla en el cds usar en terminal:
// hana-cli inspectView -v V_INTERACTION -o cds
// Se siguio este tutorial para hacer esta clacView: https://developers.sap.com/tutorials/hana-cloud-cap-calc-view.html

// usa la calcView de src/V_INTERACTION.hdbcalculationview
@cds.persistence.exists
@cds.persistence.calcview
entity![V_INTERACTION]{
    key![ID]             : Integer      @title : 'ID: ID';
    key![PARTNER]        : String(10)   @title : 'PARTNER: PARTNER';
    key![LOG_DATE]       : String       @title : 'LOG_DATE: LOG_DATE';
    key![BPCOUNTRY_CODE] : String(3)    @title : 'BPCOUNTRY_CODE: BPCOUNTRY_CODE';
    key![TEXT_ID]        : String(10)   @title : 'TEXT_ID: TEXT_ID';
    key![LANGU]          : String(2)    @title : 'LANGU: LANGU';
    key![LOGTEXT]        : String(1024) @title : 'LOGTEXT: LOGTEXT';
}

// Hay una tabla y un index en db/src/data pero que no se esta exponiendo en el servicio (si se encuentran en la db)
// para hacerlo hay que usar @cds.persistence.exists y mostrarlas en esta archivo