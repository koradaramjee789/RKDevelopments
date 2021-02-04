@EndUserText.label: 'projection for document items'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZRK_C_DOC_ITEM
  as projection on ZRK_I_DOC_ITEM
{

  key     ItemUuid,
  key       DocUuid,
          ItemNo,
          PartNo,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'zrk_i_comm_code', element: 'CommCode'} }]
          @ObjectModel.text.element: ['CommCodeDesc']
          CommCode,
          _MdCommCode.Description as CommCodeDesc,
          @Semantics.quantity.unitOfMeasure: 'Unit'
          Quantity,
          @ObjectModel.text.element: [ 'UnitDesc' ]
          @Consumption.valueHelpDefinition: [{ entity: { name: 'zrk_i_unit' , element: 'UnitOfMeasure' }}]
          Unit,
          _MdUnit.UnitOfMeasureName as UnitDesc,
          @Semantics.amount.currencyCode: 'Currency'
          Price,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency'} }]
          Currency,
          ValidFrom,
          ValidTo,
          
          GoodsReceipt,
          InvoiceReceipt,
          GrBasedInvVer,
          
          CreatedBy,
          LastChangedBy,
          LocalLastChangedAt,
          /* Associations */


          _Conds : redirected to composition child ZRK_C_ITEM_COND,
          _Head  : redirected to parent zrk_c_doc_head,
          _MdUnit
}
