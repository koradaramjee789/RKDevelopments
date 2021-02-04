@EndUserText.label: 'projection for document usage'
@AccessControl.authorizationCheck: #CHECK
define view entity ZRK_C_DOC_USAGE as projection on ZRK_I_DOC_USAGE as _Usage {
    key UsageUuid,
    key DocUuid,
    UsageId,

    /* Associations */
      _Head : redirected to parent zrk_c_doc_head
}
