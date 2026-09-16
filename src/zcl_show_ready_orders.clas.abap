CLASS zcl_show_ready_orders DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_show_ready_orders IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    SELECT order_id, dish_name, table_number, status
      FROM zc_readyorders
      ORDER BY table_number
      INTO TABLE @DATA(lt_ready).

    out->write( 'Orders ready to serve:' ).
    out->write( '-----------------------' ).

    LOOP AT lt_ready INTO DATA(ls_order).
      out->write( |Table { ls_order-table_number }: | &&
                  |{ ls_order-dish_name } (Order { ls_order-order_id })| ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
