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
    METHODS GenerateObjectId FOR DETERMINE ON SAVE
      IMPORTING keys FOR Head~GenerateObjectId.
    METHODS ReleaseDoc FOR MODIFY
      IMPORTING keys FOR ACTION Head~ReleaseDoc RESULT result.

ENDCLASS.

CLASS lhc_Head IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD extendDoc.

    DATA : lt_update_doc  TYPE TABLE FOR UPDATE zrk_i_doc_head.
    DATA(lt_keys) = keys.
    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_key>).

      IF <fs_key>-%param-extend_till < lv_today.

        APPEND VALUE #( %tky                = <fs_key>-%tky ) TO failed-head.

        APPEND VALUE #( %tky                = <fs_key>-%tky
                        %msg                = new_message(  id       = 'ZRK_CM_DOC'
                                                            number   = '001' " Document cannot be extended into the past
                                                            severity = if_abap_behv_message=>severity-error )
                        %element-ValidTo = if_abap_behv=>mk-on ) TO reported-head.

        DELETE lt_keys.


      ELSE.
        DATA(lv_valid_to) = <fs_key>-%param-extend_till.
      ENDIF.

    ENDLOOP.

    CHECK lt_keys IS NOT INITIAL.

    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Head
        FIELDS ( ValidFrom ValidTo )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_doc_head).


    CHECK lt_doc_head IS NOT INITIAL.

    MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Head
        UPDATE
        FIELDS ( ValidTo )
        WITH VALUE #( FOR <fs_doc> IN lt_doc_head
                        ( %tky = <fs_doc>-%tky
                          validTo = COND #( WHEN lv_valid_to IS NOT INITIAL
                          THEN lv_valid_to
                          ELSE <fs_doc>-ValidTo )  ) )
        REPORTED DATA(lt_update_reported).

    reported = CORRESPONDING #( DEEP lt_update_reported ).

    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Head
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT lt_doc_head.

    result = VALUE #( FOR <fs_head> IN lt_doc_head ( %tky = <fs_head>-%tky
    %param = <fs_head> ) ).

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
      FIELDS ( Supplier SendVia SendViaT )
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
    ELSEIF lv_supplier CP '*0'.
      lv_send_via = 'GST'.
    ENDIF.

    SELECT SINGLE send_via_t
         FROM zrk_md_send_via
         WHERE send_via EQ @lv_send_via
        INTO @DATA(lv_send_via_t).
    IF sy-subrc NE 0.
      CLEAR lv_send_via_t.
    ENDIF.

    lt_doc_head[ 1 ]-SendVia = lv_send_via  .
    lt_doc_head[ 1 ]-SendViaT = lv_send_via_t .


    MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Head
        UPDATE
        FIELDS ( SendVia SendViaT )
*        WITH CORRESPONDING #( lt_doc_head )
        WITH VALUE #( FOR <fs_doc> IN lt_doc_head
                        ( %tky = <fs_doc>-%tky
                          SendVia = lv_send_via
                          SendViaT = lv_send_via_t
                          %control-SendVia = if_abap_behv=>mk-on
                          %control-SendViaT = if_abap_behv=>mk-on
                           ) )
        REPORTED DATA(lt_update_reported).

    reported = CORRESPONDING #( DEEP lt_update_reported ).

  ENDMETHOD.

  METHOD GenerateObjectId.

    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Head
        FIELDS ( ObjectId ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_doc_head).

    DELETE lt_doc_head WHERE ObjectId IS NOT INITIAL.

    CHECK lt_doc_head IS NOT INITIAL.

    SELECT SINGLE
        FROM zrk_a_doc_head
        FIELDS MAX( object_id )
        AS objectId
        INTO @DATA(lv_max_object_id).

    IF lv_max_object_id IS INITIAL.
      lv_max_object_id = 29990000.
    ENDIF.

    MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Head
        UPDATE FIELDS ( ObjectId Status )
        WITH VALUE #( FOR <fs_rec> IN lt_doc_head INDEX INTO i
            ( %tky = <fs_rec>-%tky
              ObjectId = lv_max_object_id + 1
              Status = 'SAVED'
              %control-ObjectId = if_abap_behv=>mk-on ) )
              REPORTED DATA(lt_update_reported).

    reported = CORRESPONDING #( DEEP lt_update_reported ).

  ENDMETHOD.

  METHOD ReleaseDoc.

    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
      ENTITY Head
      FIELDS ( ObjectId ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_doc_head).

    CHECK lt_doc_head IS NOT INITIAL.

    MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
     ENTITY Head
     UPDATE FIELDS ( Status  )
     WITH VALUE #( FOR <fs_rec> IN lt_doc_head INDEX INTO i
     ( %tky = <fs_rec>-%tky
                     Status = 'AWAPR'
       %control-ObjectId = if_abap_behv=>mk-on ) )
       REPORTED DATA(lt_update_reported).

    reported = CORRESPONDING #( DEEP lt_update_reported ).

    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
  ENTITY Head
  ALL FIELDS  WITH CORRESPONDING #( keys )
  RESULT lt_doc_head.

    result = VALUE #( FOR <fs_head> IN lt_doc_head ( %tky = <fs_head>-%tky
                                                     %param = <fs_head> ) ).

  ENDMETHOD.

ENDCLASS.
