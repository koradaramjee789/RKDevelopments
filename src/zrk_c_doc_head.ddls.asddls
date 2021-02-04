@EndUserText.label: 'Projection view for docment header'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity zrk_c_doc_head
  as projection on zrk_i_doc_head
{
  key DocUuid,
      ObjectType,
      @Search.defaultSearchElement: true
      ObjectId,
      Title,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZRK_I_BUYER', element: 'RespBuyerId'} }]
      @ObjectModel.text.element: ['RespBuyerName']
      @Search.defaultSearchElement: true
//      @UI.lineItem: [{type: #AS_CONTACT , value: '_RespBuyer'}]
      RespBuyer,
      _RespBuyer.LastName as RespBuyerName,
      @ObjectModel.text.element: ['RespBuyerName']
      @Search.defaultSearchElement: true      
      QvRespBuyer,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZRK_I_SUPPLIER', element: 'SupplierId'} }]
      @ObjectModel.text.element: ['SupplierName']
      @Search.defaultSearchElement: true      
      Supplier,
      _Supplier.Name as SupplierName,
      
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Avob,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency'} }]
      CurrencyCode,
      ValidFrom,
      ValidTo,
      @ObjectModel.text.element: ['SendViaT']
      SendVia,
      SendViaT,
      
      Status,
      _Status.StatusColor,
      _Status.StatusText,
      
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,


      /* Associations */
      
      _Plant :  redirected to composition child ZRK_C_DOC_PLANT,
      _Items : redirected to composition child ZRK_C_DOC_ITEM,
      _Usage : redirected to composition child ZRK_C_DOC_USAGE,
      
      _Currency,
      _RespBuyer,
      _Supplier
}

