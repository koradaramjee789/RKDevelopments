CLASS zrk_cl_fill_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zrk_cl_fill_data IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*    DATA lt_copy TYPE TABLE OF zrk_supplier.
*
*    SELECT FROM /dmo/agency FIELDS client , agency_id AS supplier_id, name , street, postal_code  ,city ,
*      country_code , phone_number ,email_address ,
*       web_address
*    INTO TABLE @lt_copy.
*
*    MODIFY zrk_supplier FROM TABLE @lt_copy.
*
*    commit WORK.


*    DATA lt_plant TYPE TABLE OF zrk_md_plant.
*
*    lt_plant = VALUE #( ( plant_id = '1350' name = 'RK Manufactures Pvt, Hyderabad' )
*                        ( plant_id = '2350' name = 'RK Manufactures Pvt, Bangalore' )
*                        ( plant_id = '3350' name = 'RK Manufactures Pvt, Pune' )
*                        ( plant_id = '4350' name = 'RK Manufactures Pvt, Mumbai' )
*                        ( plant_id = '5350' name = 'RK Manufactures Pvt, Chennai' ) ).
*
*
*    MODIFY  zrk_md_plant FROM TABLE @lt_plant.
*
*    COMMIT WORK.

    DATA : lt_send_via TYPE TABLE OF zrk_md_send_via.

    lt_send_via = VALUE #( ( send_via = 'EDC' send_via_t = 'EDoc' )
    ( send_via = 'MAI' send_via_t = 'Email' )
    ( send_via = 'PRN' send_via_t = 'Print' )
    ( send_via = 'GST' send_via_t = 'Guest' ) ).

    MODIFY zrk_md_send_via FROM TABLE @lt_send_via.

    COMMIT WORK.


  ENDMETHOD.
ENDCLASS.
