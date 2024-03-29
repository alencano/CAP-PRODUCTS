namespace com.logali;

define type Name : String(50);

type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    Postalcode : String(5);
    Country    : String(3);
};
// type EmailsAddresses_01 : many {
//     Kind  : String;
//     email : String;
// };

// type EmailsAddresses_02 {
//     Kind  : String;
//     email : String;
// };

// entity Emails {
//     email_01 :      EmailsAddresses_01;
//     email_02 : many EmailsAddresses_02;
//     email_03 : many {
//         Kind  : String;
//         email : String;
//     }
// }

// Type Gender : String enum {
//      male;
//      female;
// }

// entity Order {
//      clientGender : Gender;
//      status       : Integer enum {
//         submitted = 1;
//         filfiller = 2;
//         shipped   = 3;
//         cancel    = -1;
//      };
//      priority : String @assert.range enum {
//         high:
//         medium;
//         low;
//      }
// }

entity Car {
    key ID                 : UUID;
        name               : String;
        virtual discount_1 : Decimal;
        @core.Computed: false
        virtual discount_2 : Decimal;
}

entity Products {
    key ID               : UUID;
        Name             : String not null;
        Description      : String;
        ImageUrl         : String;
        ReleaseDate      : DateTime default $now;
        DiscontinuedDate : DateTime;
        Price            : Decimal(16, 2);
        Height           : type of Price; // Decimal(16, 2);
        Width            : Decimal(16, 2);
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
        Supplier         : Association to Suppliers;
        UnitOfMeasure    : Association to UnitOfMeasures;
        Currency         : Association to Currencies;
        DimensionUnits   : Association to DimensionUnits;
        Category         : Association to Categories;
        SalesData        : Association to many SalesData
                           on SalesData.Product = $self;
        Reviews          : Association to many ProductReview
                           on Reviews.Product = $self;                   
}

entity Suppliers {
    key ID      : UUID;
        Name    : type of Products : Name; // String;
        Address : Address;
        Email   : String;
        Phone   : String;
        Fax     : String;
        Product : Association to many Products
                        on Product.Supplier = $self;  
}

entity Categories {
    key ID   : String(1);
        Name : String;
}

entity StockAvailability {
    key ID          : Integer;
        Description : String;
}

entity Currencies {
    key ID          : String(3);
        Description : String;
}

entity UnitOfMeasures {
    key ID          : String(2);
        Description : String;
}

entity DimensionUnits {
    key ID          : String(2);
        Description : String;
}

entity Months {
    key ID               : String(2);
        Description      : String;
        ShortDescription : String(3);
}

entity ProductReview {
    key ID      : UUID;
        Name    : String;
        Rating  : Integer;
        Comment : String;
        Product : Association to  Products;
}

entity SalesData {
    key ID           : UUID;
        DeliveryDate : DateTime;
        Revenue      : Decimal(16, 2);
        Product      : Association to Products;
        Currency     : Association to Currencies;
        DeliveryMonth : Association to Months;
};

entity SelProducts  as select from Products;

entity SelProducts1 as
    select from Products {
        *
    };

entity SelProducts2 as
    select from Products {
        Name,
        Price,
        Quantity
    };

entity SelProducts3 as
    select from Products
    left join ProductReview
        on Products.Name = ProductReview.Name
    {
        Rating,
        Products.Name,
        sum(Price) as TotalPrice
    }
    group by
        Rating,
        Products.Name
    order by
        Rating;

entity ProjProducts as projection on Products;

entity ProjProducts2 as projection on Products {
    *
};

entity ProjProducts3 as projection on Products {
    ReleaseDate, Name
};

// entity ParamProducts(pName : String)     as
//     select from Products {
//         Name,
//         Price,
//         Quantity
//     }
//     where
//         Name = : pName;

// entity PromParamProducts(pName : String) as projection on Products where Name = : pName;

extend Products with {
    PriceCondition: String(2);
    PriceDetermination: String(3);
}

