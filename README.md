SAP ABAP Demo: Expiring Products Alert

A small end-to-end SAP ABAP project demonstrating core backend development concepts: custom database tables, object-oriented ABAP, and CDS Views for business-rule-driven data filtering.

Business Scenario

A pharmacy or warehouse needs to identify products approaching their expiry date, so staff can prioritize selling or removing them before they expire. This project models that requirement using standard SAP development patterns.

What This Project Demonstrates
Custom Database Table Design — defining a transparent table with appropriate key fields and data types
Object-Oriented ABAP — a class implementing IF_OO_ADT_CLASSRUN to load test data programmatically
CDS Views — encapsulating business logic (the "expiring soon" rule) at the data-model layer, rather than scattering filter logic across multiple consuming programs
Debugging & Verification — using the SQL Console to isolate logic issues from CDS-layer syntax issues during development

Project Structure
Object	Type	Purpose
ZEXPIRING_PROD	Database Table	Stores product records: ID, name, expiry date, quantity
ZCL_LOAD_TEST_DATA	ABAP Class	Loads sample test data into the table
Z_C_ExpiringProd	CDS View	Filters products expiring within a defined threshold
Database Table: ZEXPIRING_PROD

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
Data Loader Class: ZCL_LOAD_TEST_DATA
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
CDS View: Z_C_ExpiringProd
abap
@AbapCatalog.sqlViewName: 'ZVEXPPROD'
@EndUserText.label: 'Expiring Products CDS View'
define view Z_C_ExpiringProd as select from zexpiring_prod {
  key product_id,
  product_name,
  expiry_date,
  quantity
} where expiry_date <= '20261016'

Note: this version uses a fixed date threshold for demonstration purposes. A production implementation would calculate this dynamically relative to the current system date.

Result

Querying the CDS View correctly returns only products expiring within the defined window (Aspirin, Ibuprofen), while excluding products with a later expiry date (Paracetamol) — confirming the business rule is enforced at the data layer.

What I Learned Building This
How SAP structures custom development inside packages, and how local/structure packages differ from development packages
The relationship between database tables, CDS Views, and how business logic can be pushed down to the data layer rather than handled repeatedly in application code
Practical debugging: using the SQL Console to isolate whether an issue was in the underlying data/logic or in the CDS view syntax itself
Hands-on use of SAP BTP ABAP Environment (cloud/"ABAP Cloud") development via Eclipse and ABAP Development Tools (ADT)
Tech Stack
SAP BTP ABAP Environment (Trial)
Eclipse with ABAP Development Tools (ADT)
ABAP Cloud (class-based, restricted syntax)
Core Data Services (CDS)
