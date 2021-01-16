@EndUserText.label: 'projection for document item Conditions'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZRK_C_ITEM_COND as projection on zrk_i_item_cond {
    key CondUuid,
    ItemUuid,
    DocUuid,
    CondType,
    @Semantics.amount.currencyCode: 'Currency'
    Price,
    @Semantics.currencyCode: true
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency'} }]
    Currency,
    ValidFrom,
    ValidTo,
    CreatedBy,
    LastChangedBy,
    LocalLastChangedAt,
    /* Associations */
    _Items : redirected to parent ZRK_C_DOC_ITEM,
    _Head : redirected to zrk_c_doc_head
    
}
