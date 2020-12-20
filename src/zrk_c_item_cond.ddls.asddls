@EndUserText.label: 'projection for document item Conditions'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZRK_C_ITEM_COND as projection on zrk_i_item_cond {
    key CondUuid,
    ItemUuid,
    DocUuid,
    CondType,
    Price,
    Currency,
    CreatedBy,
    LastChangedBy,
    LocalLastChangedAt,
    /* Associations */
    _Items : redirected to parent ZRK_C_DOC_ITEM,
    _Head : redirected to zrk_c_doc_head
    
}
