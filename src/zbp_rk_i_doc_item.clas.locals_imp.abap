CLASS lhc_items DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS initializeItem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Items~initializeItem.

ENDCLASS.

CLASS lhc_items IMPLEMENTATION.

  METHOD initializeItem.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
