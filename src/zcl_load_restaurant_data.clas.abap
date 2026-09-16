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
