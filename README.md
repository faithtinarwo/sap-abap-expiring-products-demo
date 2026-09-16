SAP ABAP Learning Projects

A collection of small, self-contained SAP ABAP projects built while learning core backend development concepts: custom database tables, object-oriented ABAP, CDS Views, OData services, and Fiori Elements UIs.

This repo contains two separate demo scenarios, each demonstrating a different depth of the SAP development stack.

Project 1: Expiring Products Alert

Business Scenario: A pharmacy or warehouse needs to identify products approaching their expiry date, so staff can prioritize selling or removing them before they expire.

What It Demonstrates
Custom database table design
Object-oriented ABAP (IF_OO_ADT_CLASSRUN) to load test data
A CDS View encapsulating business logic (the "expiring soon" rule) at the data-model layer
Objects
Object	Type	Purpose
ZEXPIRING_PROD	Database Table	Stores product records: ID, name, expiry date, quantity
ZCL_LOAD_TEST_DATA	ABAP Class	Loads sample test data into the table
Z_C_ExpiringProd	CDS View	Filters products expiring within a defined threshold
Database Table
abap
@EndUserText.label : 'Expiring Products Demo Table'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
define table zexpiring_prod {
  key client       : abap.clnt not null;
  key product_id   : abap.char(10) not null;
  product_name     : abap.char(40);
  expiry_date      : abap.dats;
  quantity         : abap.int4;
}
Data Loader Class
abap
CLASS zcl_load_test_data DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_load_test_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DELETE FROM zexpiring_prod.

    INSERT zexpiring_prod FROM TABLE @( VALUE #(
      ( product_id = 'P001' product_name = 'Aspirin 500mg' expiry_date = '20261005' quantity = 50 )
      ( product_id = 'P002' product_name = 'Paracetamol'   expiry_date = '20261215' quantity = 200 )
      ( product_id = 'P003' product_name = 'Ibuprofen'     expiry_date = '20260926' quantity = 5 )
    ) ).

    out->write( 'Test data loaded successfully.' ).

  ENDMETHOD.

ENDCLASS.
CDS View
abap
@AbapCatalog.sqlViewName: 'ZVEXPPROD'
@EndUserText.label: 'Expiring Products CDS View'
define view Z_C_ExpiringProd as select from zexpiring_prod {
  key product_id,
  product_name,
  expiry_date,
  quantity
} where expiry_date <= '20261016'

Note: uses a fixed date threshold for demonstration purposes. A production version would calculate this dynamically relative to the current system date.

Result

Querying the CDS View correctly returns only products expiring within the defined window (Aspirin, Ibuprofen), while excluding products with a later expiry date (Paracetamol).

Project 2: Restaurant Order System (Full CDS → OData → Fiori Chain)

Business Scenario: A restaurant kitchen manages orders, and waitstaff need a simple UI showing only the dishes that are ready to serve — not the ones still cooking.

This project goes a step further than Project 1: it exposes the CDS View as a live OData service and generates a working Fiori Elements UI, demonstrating the full modern SAP development stack end-to-end.

What It Demonstrates
Everything from Project 1 (table, OO ABAP, CDS View)
UI annotations on a CDS View (@UI.headerInfo, @UI.lineItem) to drive Fiori Elements rendering
A Service Definition, exposing a CDS View as a consumable service
A Service Binding (OData V4), publishing that service live
A generated Fiori Elements preview — a real, working browser-based UI, built with zero manual frontend code
Objects
Object	Type	Purpose
ZRESTAURANT_ORDE	Database Table	Stores orders: ID, dish name, table number, status
ZCL_LOAD_RESTAURANT_DATA	ABAP Class	Loads sample order data
ZC_READYORDERS	CDS View Entity	Filters orders with status = READY, annotated for UI
ZSD_READYORDERS	Service Definition	Exposes the CDS View as a service
ZSB_READYORDERS	Service Binding	Publishes the service as OData, enabling the Fiori preview
Database Table
abap
@EndUserText.label : 'Restaurant Order Demo Table'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
define table zrestaurant_orde {
  key client       : abap.clnt not null;
  key order_id     : abap.char(10) not null;
  dish_name        : abap.char(40);
  table_number     : abap.int4;
  status           : abap.char(10);
}
Data Loader Class
abap
CLASS zcl_load_restaurant_data DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_load_restaurant_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DELETE FROM zrestaurant_orde.

    INSERT zrestaurant_orde FROM TABLE @( VALUE #(
      ( order_id = 'O001' dish_name = 'Margherita Pizza' table_number = 4 status = 'COOKING' )
      ( order_id = 'O002' dish_name = 'Chicken Burger'   table_number = 2 status = 'READY' )
      ( order_id = 'O003' dish_name = 'Caesar Salad'     table_number = 7 status = 'READY' )
      ( order_id = 'O004' dish_name = 'Steak'            table_number = 4 status = 'COOKING' )
    ) ).

    out->write( 'Restaurant orders loaded successfully.' ).

  ENDMETHOD.

ENDCLASS.
CDS View Entity (with UI annotations)
abap
@EndUserText.label: 'Ready-to-Serve Orders CDS View'
@UI.headerInfo: { typeName: 'Order', typeNamePlural: 'Ready Orders' }
define root view entity ZC_READYORDERS
  as select from zrestaurant_orde
{
  key order_id,
  @UI.lineItem: [{ position: 10 }]
  dish_name,
  @UI.lineItem: [{ position: 20 }]
  table_number,
  @UI.lineItem: [{ position: 30 }]
  status
}
where status = 'READY'
Service Definition
abap
@EndUserText.label: 'Ready Orders Service Definition'
define service ZSD_READYORDERS {
  expose ZC_READYORDERS as ReadyOrders;
}
Service Binding

Created as an OData V4 - UI binding, published directly from Eclipse's Service Binding editor, generating a live Fiori Elements preview.

Result

Opening the Fiori Elements preview shows a real, working web UI listing only the two "READY" orders (Chicken Burger — Table 2, Caesar Salad — Table 7), with the two "COOKING" orders correctly excluded — no manual frontend code written.

What I Learned Building These
How SAP structures custom development inside packages, and how local/structure packages differ from development packages
The relationship between database tables, CDS Views, and pushing business logic down to the data layer instead of repeating it across consuming programs
The modern CDS View Entity syntax (define root view entity), replacing the older define view syntax as of AS ABAP 7.57
How a CDS View becomes a consumable OData service via a Service Definition and Service Binding, and how UI annotations drive an auto-generated Fiori Elements screen
Practical debugging: isolating logic errors from syntax errors using the SQL Console, and tracing "no data returned" issues back to a step that was updated but never re-run
Naming constraints (16-character table name limits) and how entity names must exactly match their DDL source name in modern CDS syntax
Tech Stack
SAP BTP ABAP Environment (Trial)
Eclipse with ABAP Development Tools (ADT)
ABAP Cloud (class-based, restricted syntax)
Core Data Services (CDS) — classic views and modern View Entities
OData V4
SAP Fiori Elements
ABAP Cloud (class-based, restricted syntax)
Core Data Services (CDS)
