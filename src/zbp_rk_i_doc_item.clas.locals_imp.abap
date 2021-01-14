CLASS lhc_items DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS initializeItem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Items~initializeItem.
    METHODS CalculateItemAvob FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Items~CalculateItemAvob.

ENDCLASS.

CLASS lhc_items IMPLEMENTATION.

  METHOD initializeItem.

    DATA: lv_max_item_no TYPE zrk_de_item_no,
          lt_item_update TYPE TABLE FOR UPDATE zrk_i_doc_head\\Items.

    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Items BY \_Head
        FIELDS ( DocUuid CurrencyCode )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_head).

    LOOP AT lt_head ASSIGNING FIELD-SYMBOL(<fs_head>).

      CLEAR lv_max_item_no.

      READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
          ENTITY Head BY \_Items
          FIELDS ( ItemNo )
          WITH VALUE #( ( %tky = <fs_head>-%tky ) )
          RESULT DATA(lt_item).

      LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
        IF <fs_item>-ItemNo > lv_max_item_no .
          lv_max_item_no = <fs_item>-ItemNo.
        ENDIF.
      ENDLOOP.

      LOOP AT lt_item ASSIGNING <fs_item>
                        WHERE ItemNo IS INITIAL .
        lv_max_item_no += 10.

        APPEND VALUE #( %tky = <fs_item>-%tky
                        ItemNo = lv_max_item_no
                        currency = <fs_head>-CurrencyCode )
                        TO lt_item_update .

      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Items
            UPDATE FIELDS ( ItemNo Currency ) WITH lt_item_update
            REPORTED DATA(lt_update_reported).

    reported = CORRESPONDING #( DEEP lt_update_reported ).


  ENDMETHOD.

  METHOD CalculateItemAvob.


    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
      ENTITY Items BY \_Head
      FIELDS ( DocUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_head).

    MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Head
        EXECUTE reCalcDocAvob
        FROM CORRESPONDING #( lt_head )
        REPORTED DATA(lt_reported).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
