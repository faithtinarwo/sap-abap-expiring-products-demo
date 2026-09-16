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
