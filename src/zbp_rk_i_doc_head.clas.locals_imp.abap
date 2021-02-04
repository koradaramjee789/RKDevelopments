CLASS lhc_Head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
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
    METHODS reCalcDocAvob FOR MODIFY
      IMPORTING keys FOR ACTION Head~reCalcDocAvob.
    METHODS approveDoc FOR MODIFY
      IMPORTING keys FOR ACTION Head~approveDoc RESULT result.

    METHODS rejectDoc FOR MODIFY
      IMPORTING keys FOR ACTION Head~rejectDoc RESULT result.
    METHODS ForwardDoc FOR MODIFY
      IMPORTING keys FOR ACTION Head~ForwardDoc RESULT result.

ENDCLASS.

CLASS lhc_Head IMPLEMENTATION.

  METHOD get_features.

    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
       ENTITY Head
       FIELDS ( Status )
       WITH CORRESPONDING #( keys )
       RESULT DATA(lt_doc_head).

    result = VALUE #( FOR <fs_head> IN lt_doc_head

    (

     %tky = <fs_head>-%tky
     %action-ReleaseDoc = COND #( WHEN <fs_head>-Status EQ 'RELSD'
                                  THEN if_abap_behv=>fc-o-disabled
                                  ELSE if_abap_behv=>fc-o-enabled )
     %action-Edit = COND #( WHEN <fs_head>-Status EQ 'RELSD'
                                  THEN if_abap_behv=>fc-o-disabled
                                  ELSE if_abap_behv=>fc-o-enabled )
     %action-approveDoc = COND #( WHEN <fs_head>-Status EQ 'AWAPR'
                                  THEN if_abap_behv=>fc-o-enabled
                                  ELSE if_abap_behv=>fc-o-disabled )
     %action-rejectDoc = COND #( WHEN <fs_head>-Status EQ 'AWAPR'
                                  THEN if_abap_behv=>fc-o-enabled
                                  ELSE if_abap_behv=>fc-o-disabled )
    )
    ) .

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
        DATA(lv_new_valid_to) = <fs_key>-%param-extend_till.
      ENDIF.

    ENDLOOP.

    " Once the validations are passed, proceed with extending document.
    CHECK lt_keys IS NOT INITIAL.

    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Head
        FIELDS ( ValidFrom ValidTo )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_doc_head).


    CHECK lt_doc_head IS NOT INITIAL.

    LOOP AT lt_doc_head ASSIGNING FIELD-SYMBOL(<fs_head>).

      " Capture old valid to
      DATA(lv_old_valid_to) = <fs_head>-ValidTo.

      " Read items from entity
      READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
          ENTITY Head BY \_Items
          FIELDS ( ValidFrom ValidTo )
          WITH VALUE #( ( %tky = <fs_head>-%tky ) )
          RESULT DATA(lt_items).

      " Loop through items that are running on old valid to
      LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_item>)
                            WHERE ValidFrom LE lv_old_valid_to
                               AND ValidTo GE lv_old_valid_to.

        " Modify item with new valid to
        <fs_item>-ValidTo = lv_new_valid_to.

        " Read conditions from entity
        READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
            ENTITY Items BY \_Conds
            FIELDS ( ValidFrom ValidTo )
            WITH VALUE #( ( %tky = <fs_item>-%tky ) )
            RESULT DATA(lt_conds).

            LOOP AT lt_conds ASSIGNING FIELD-SYMBOL(<fs_conds>)
                                    WHERE ValidFrom LE lv_old_valid_to
                                     AND ValidTo GE lv_old_valid_to..

              <fs_conds>-ValidTo = lv_new_valid_to.

            ENDLOOP.

            " Modify conditions entity
            MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
                ENTITY Conds
                UPDATE FIELDS ( ValidTo )
                WITH CORRESPONDING #( lt_conds ).


      ENDLOOP.

      " Modify Items entity
      MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
            ENTITY Items
            UPDATE FIELDS ( ValidTo )
            WITH CORRESPONDING #( lt_items ).


    ENDLOOP.

    " Modify header entity
    MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Head
        UPDATE
        FIELDS ( ValidTo )
        WITH VALUE #( FOR <fs_doc> IN lt_doc_head
                        ( %tky = <fs_doc>-%tky
                          validTo = COND #( WHEN lv_new_valid_to IS NOT INITIAL
                          THEN lv_new_valid_to
                          ELSE <fs_doc>-ValidTo )  ) )
        REPORTED DATA(lt_update_reported).

    reported = CORRESPONDING #( DEEP lt_update_reported ).

    " Return result to UI
    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
        ENTITY Head
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT lt_doc_head.

    result = VALUE #( FOR <fs_doc_head> IN lt_doc_head ( %tky = <fs_doc_head>-%tky
    %param = <fs_doc_head> ) ).

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
                          ValidFrom = '20210101'
                          validTo = '20211231' ) )
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

  METHOD reCalcDocAvob.


    READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
      ENTITY Head
      FIELDS ( Avob CurrencyCode )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_head)
      FAILED failed.

    LOOP AT lt_head ASSIGNING FIELD-SYMBOL(<fs_head>).

      CLEAR <fs_head>-Avob.

      READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
          ENTITY Head BY \_Items
          FIELDS ( Quantity Price Currency )
          WITH VALUE #( ( %tky = <fs_head>-%tky ) )
          RESULT DATA(lt_items).

      LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_item>).

        READ ENTITIES OF zrk_i_doc_head IN LOCAL MODE
            ENTITY Items BY \_Conds
            FIELDS ( Price Currency )
            WITH VALUE #( ( %tky = <fs_item>-%tky ) )
            RESULT DATA(lt_conds).

        CLEAR <fs_item>-Price.

        LOOP AT lt_conds ASSIGNING FIELD-SYMBOL(<fs_conds>).

          <fs_item>-Price = <fs_item>-Price + <fs_conds>-Price.

        ENDLOOP.

        <fs_item>-Price *=  <fs_item>-Quantity .

        MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
            ENTITY Items
            UPDATE FIELDS ( Price )
            WITH CORRESPONDING #( lt_items ).

        <fs_head>-Avob +=  <fs_item>-Price   .


      ENDLOOP.

      MODIFY ENTITIES OF zrk_i_doc_head IN LOCAL MODE
          ENTITY Head
          UPDATE FIELDS ( Avob )
          WITH CORRESPONDING #( lt_head ).

    ENDLOOP.


  ENDMETHOD.

  METHOD approveDoc.
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
                     Status = 'RELSD'
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

  METHOD rejectDoc.
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
                     Status = 'REJCT'
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

  METHOD ForwardDoc.
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
                     Status = 'REJCT'
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
