CLASS lhc_Head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Head RESULT result.
    METHODS extendDoc FOR MODIFY
      IMPORTING keys FOR ACTION Head~extendDoc RESULT result.
    METHODS initializeDoc FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Head~initializeDoc.
    METHODS setSendVia FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Head~setSendVia.

ENDCLASS.

CLASS lhc_Head IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD extendDoc.
  ENDMETHOD.

  METHOD initializeDoc.

    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Head
        FIELDS ( ValidFrom ValidTo )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_doc_head).

    DELETE lt_doc_head WHERE ValidFrom IS NOT INITIAL
                          OR ValidTo IS NOT INITIAL.

    CHECK lt_doc_head IS NOT INITIAL.

    MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Head
        UPDATE
        FIELDS ( ValidFrom ValidTo )
        WITH VALUE #( FOR <fs_doc> IN lt_doc_head
                        ( %tky = <fs_doc>-%tky
                          ValidFrom = '20200101'
                          validTo = '20201231' ) )
        REPORTED DATA(lt_update_reported).

    reported = CORRESPONDING #( DEEP lt_update_reported ).

  ENDMETHOD.

  METHOD setSendVia.

    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
      ENTITY Head
      FIELDS ( ValidFrom ValidTo )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_doc_head).

    CHECK lt_doc_head IS NOT INITIAL.

    DATA(lv_supplier) = VALUE #( lt_doc_head[ 1 ]-Supplier OPTIONAL ).

    IF lv_supplier CP '*1'
        OR lv_supplier CP '*2'
        OR lv_supplier CP '*3'.
      DATA(lv_send_via) = 'EDC'.

    ELSEIF lv_supplier CP '*4'
        OR lv_supplier CP '*5'
        OR lv_supplier CP '*6'..
      lv_send_via = 'MAI'.
    ELSEIF lv_supplier CP '*7'
        OR lv_supplier CP '*8'
        OR lv_supplier CP '*9'.
      lv_send_via = 'PRN'.
    ELSE.
      lv_send_via = 'GST'.
    ENDIF.

    SELECT SINGLE send_via_t
         FROM zrk_md_send_via
         WHERE send_via EQ @lv_send_via
        INTO @DATA(lv_send_via_t).
    IF sy-subrc NE 0.
      CLEAR lv_send_via_t.
    ENDIF.

    MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Head
        UPDATE
        FIELDS ( ValidFrom ValidTo )
        WITH VALUE #( FOR <fs_doc> IN lt_doc_head
                        ( %tky = <fs_doc>-%tky
                          SendVia = lv_send_via
                           ) )
        REPORTED DATA(lt_update_reported).

    reported = CORRESPONDING #( DEEP lt_update_reported ).

  ENDMETHOD.

ENDCLASS.