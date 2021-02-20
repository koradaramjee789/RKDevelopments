CLASS zrk_cl_fill_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZRK_CL_FILL_DATA IMPLEMENTATION.


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

*==================================================================================================
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
*==================================================================================================
*    DATA : lt_send_via TYPE TABLE OF zrk_md_send_via.
*
*    lt_send_via = VALUE #( ( send_via = 'EDC' send_via_t = 'EDoc' )
*    ( send_via = 'MAI' send_via_t = 'Email' )
*    ( send_via = 'PRN' send_via_t = 'Print' )
*    ( send_via = 'GST' send_via_t = 'Guest' ) ).
*
*    MODIFY zrk_md_send_via FROM TABLE @lt_send_via.
*==================================================================================================
*    DELETE FROM zrk_md_comm_code .
*
*    DATA : lt_comm_code TYPE TABLE OF zrk_md_comm_code.
*    lt_comm_code = VALUE #(
*
*        ( comm_code =  'CC_525-05' description = 'Archival Storage Materials')
*        ( comm_code =  'CC_525-50' description = 'Books, Accession')
*        ( comm_code =  'CC_530-15' description = 'Attache Cases')
*        ( comm_code =  'CC_540-14' description = 'Lumber, Cedar')
*        ( comm_code =  'CC_540-87' description = 'Siding, Prefinished Particleboard')
*        ( comm_code =  'CC_540-77' description = 'Recycled Lumber')
*        ( comm_code =  'CC_545-46' description = 'Mills, Iron and Steel')
*        ( comm_code =  'CC_545-54' description = 'Planers, Electric')
*        ( comm_code =  'CC_545-82' description = 'Shredder, Metal/wood')
*        ( comm_code =  'CC_555-50' description = 'Stenciling Rollers')
*        ( comm_code =  'CC_557-20' description = 'Brake Parts/linings')
*        ( comm_code =  'CC_557-65' description = 'Steering Components and Parts')
*        ).
*
*    MODIFY zrk_md_comm_code FROM TABLE @lt_comm_code.

*==================================================================================================

*    DATA : lt_status TYPE TABLE OF zrk_md_status.
*
*    DELETE FROM zrk_md_status    .
*
*    lt_status = VALUE #(
*            ( status = 'SAVED' status_text = 'Saved' status_color = 0 )
*            ( status = 'AWAPR' status_text = 'Awaiting approval' status_color = 2 )
*            ( status = 'REJCT' status_text = 'Rejected' status_color = 1 )
*            ( status = 'RELSD' status_text = 'Released' status_color = 3 )
*            )  .
*
*    MODIFY zrk_md_status FROM TABLE @lt_status.

*==================================================================================================

*       DATA : lt_usage TYPE TABLE OF zrk_md_usage.
*
*    DELETE FROM zrk_md_usage    .
*
*    lt_usage = VALUE #(
*            ( usage_id = 'USG01' description = 'Buses'  )
*            ( usage_id = 'USG02' description = 'Cars'  )
*            ( usage_id = 'USG03' description = 'Bikes'  )
*            ( usage_id = 'USG04' description = 'Trucks'  )
*            )  .
*
*    MODIFY zrk_md_usage FROM TABLE @lt_usage.

*    DELETE FROM zrk_price_det.
*
*    DATA : lt_price_det TYPE TABLE OF zrk_price_det.
*
*    lt_price_det = VALUE #(
*
*    ( part_no = 'A00012' plant = '2560' valid_from = '20210101' valid_to = '20211231' price = 10 currency_code = 'INR' )
*    ( part_no = 'A00012' plant = '3420' valid_from = '20210101' valid_to = '20210531' price = 12 currency_code = 'INR' )
*    ( part_no = 'A00012' plant = '3420' valid_from = '20210601' valid_to = '20211231' price = 15 currency_code = 'INR' )
*    ( part_no = 'B11123' plant = '3420' valid_from = '20210101' valid_to = '20210331' price = 25 currency_code = 'INR' )
*    ( part_no = 'B11123' plant = '3420' valid_from = '20210401' valid_to = '20210831' price = 30 currency_code = 'INR' )
*    ( part_no = 'B11123' plant = '3420' valid_from = '20210901' valid_to = '20211231' price = 40 currency_code = 'INR' )
*    ( part_no = 'B11123' plant = '1250' valid_from = '20210101' valid_to = '20210930' price = 30 currency_code = 'INR' )
*    ( part_no = 'B11123' plant = '1250' valid_from = '20211001' valid_to = '20211231' price = 32 currency_code = 'INR' )
*    ( part_no = 'B11123' plant = '4578' valid_from = '20210101' valid_to = '20211231' price = 35 currency_code = 'INR' )
*    ( part_no = 'A00012' plant = '8850' valid_from = '20210101' valid_to = '20211231' price = 5 currency_code = 'INR' )
*     ).
*
*
*    MODIFY zrk_price_det FROM TABLE @lt_price_det.

    DELETE FROM zrk_quant_det.

    DATA : lt_quant_det TYPE TABLE OF zrk_quant_det.

    lt_quant_det = VALUE #(

    ( part_no = 'A00012' plant = '2560' valid_from = '20210101' valid_to = '20211231' quantity = 50 uom   = 'EA' )
    ( part_no = 'A00012' plant = '3420' valid_from = '20210101' valid_to = '20210531' quantity = 20 uom   = 'EA' )
    ( part_no = 'A00012' plant = '3420' valid_from = '20210601' valid_to = '20211231' quantity = 30 uom   = 'EA' )
    ( part_no = 'B11123' plant = '3420' valid_from = '20210101' valid_to = '20210331' quantity = 25 uom   = 'KG' )
    ( part_no = 'B11123' plant = '3420' valid_from = '20210401' valid_to = '20210831' quantity = 50 uom   = 'KG' )
    ( part_no = 'B11123' plant = '3420' valid_from = '20210901' valid_to = '20211231' quantity = 25 uom   = 'KG' )
    ( part_no = 'B11123' plant = '1250' valid_from = '20210101' valid_to = '20210930' quantity = 40 uom   = 'KG' )
    ( part_no = 'B11123' plant = '1250' valid_from = '20211001' valid_to = '20211231' quantity = 20 uom   = 'KG' )
    ( part_no = 'B11123' plant = '4578' valid_from = '20210101' valid_to = '20211231' quantity = 55 uom   = 'KG' )
    ( part_no = 'A00012' plant = '8850' valid_from = '20210101' valid_to = '20211231' quantity = 80 uom   = 'PC' )
     ).


    MODIFY zrk_quant_det FROM TABLE @lt_quant_det.

    COMMIT WORK.


  ENDMETHOD.
ENDCLASS.
