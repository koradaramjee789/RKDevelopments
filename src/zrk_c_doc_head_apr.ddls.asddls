@EndUserText.label: 'Projection for document approver'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZRK_C_DOC_HEAD_APR as projection on zrk_i_doc_head {
    key DocUuid,
    ObjectId,
    Title,
    RespBuyer,
    Supplier,
    Avob,
    CurrencyCode,
    ValidFrom,
    ValidTo,
    SendVia,
    SendViaT,
    Status,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt,
    /* Associations */
    _Currency,
    _Items,
    _Plant,
    _RespBuyer,
    _SendVia,
    _Status,
    _Supplier
}
where Status = 'AWAPR'
