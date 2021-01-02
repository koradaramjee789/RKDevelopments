@EndUserText.label: 'projection for document items'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZRK_C_DOC_ITEM
  as projection on ZRK_I_DOC_ITEM
{

  key     ItemUuid,
          DocUuid,
          ItemNo,
          PartNo,
          CommCode,
          @Semantics.quantity.unitOfMeasure: 'Unit'
          Quantity,
          Unit,
          @Semantics.amount.currencyCode: 'Currency'
          Price,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency'} }]
          Currency,
          CreatedBy,
          LastChangedBy,
          LocalLastChangedAt,
          /* Associations */


          _Conds : redirected to composition child ZRK_C_ITEM_COND,
          _Head  : redirected to parent zrk_c_doc_head
}
