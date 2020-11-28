@EndUserText.label: 'projection for document items'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZRK_C_DOC_ITEM 
as projection on ZRK_I_DOC_ITEM {
    key ItemUuid,
    DocUuid,
    ItemNo,
    PartNo,
    CommCode,
    Quantity,
    Unit,
    Price,
    Currency,

    /* Associations */
    _Head : redirected to parent zrk_c_doc_head
}
