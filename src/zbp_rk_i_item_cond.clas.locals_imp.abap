CLASS lhc_conds DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS initializeCondRec FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Conds~initializeCondRec.
    METHODS CalculateItemPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Conds~CalculateItemPrice.

ENDCLASS.

CLASS lhc_conds IMPLEMENTATION.

  METHOD initializeCondRec.

    DATA lt_cond_update TYPE TABLE FOR UPDATE zrk_i_doc_head\\Conds.

    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
      ENTITY Conds BY \_Items
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_item>).
      READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
    ENTITY Items BY \_Conds
    ALL FIELDS WITH VALUE #( (  %tky = <fs_item>-%tky ) )
    RESULT DATA(lt_item_conds).

*      IF lt_item_conds IS INITIAL.
*        DATA(lv_initial) =  abap_true.
*      ENDIF.
*
*      describe TABLE lt_item_conds LINES DATA(lv_cond_rec).

      IF line_exists( lt_item_conds[ CondType = 'CND1' ] ).

        DATA(lv_cnd1_exists) = abap_true.

      ENDIF.
      LOOP AT lt_item_conds ASSIGNING FIELD-SYMBOL(<fs_item_cond>).

        APPEND VALUE #( %tky = <fs_item_cond>-%tky
                        CondType = COND #(
                            WHEN lv_cnd1_exists IS NOT INITIAL
                            THEN <fs_item_cond>-CondType
                            ELSE'CND1' )
                        Currency = COND #(
                        WHEN <fs_item_cond>-Currency IS NOT INITIAL
                            THEN <fs_item_cond>-Currency
                            ELSE <fs_item>-Currency ) ) TO lt_cond_update .

      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Conds
        UPDATE FIELDS ( CondType Currency )
        WITH lt_cond_update
       REPORTED DATA(lt_reported).

    reported = CORRESPONDING #( DEEP lt_reported ).


  ENDMETHOD.

  METHOD CalculateItemPrice.

    READ ENTITIES Of zrk_i_doc_head IN LOCAL MODE
        ENTITY Conds BY \_Head
        FIELDS ( DocUuid )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_head).

    MODIFY ENTITIES of zrk_i_doc_head IN LOCAL MODE
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
