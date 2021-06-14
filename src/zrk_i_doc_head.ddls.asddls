@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View for document deader'

define root view entity zrk_i_doc_head
  as select from zrk_a_doc_head

  composition [0..*] of zrk_i_doc_plant as _Plant

  composition [0..*] of ZRK_I_DOC_ITEM  as _Items
  
  composition [1..*] of ZRK_I_DOC_USAGE as _Usage

  association [0..1] to zrk_i_supplier  as _Supplier  on $projection.Supplier = _Supplier.SupplierId
  association [0..1] to zrk_i_buyer     as _RespBuyer on $projection.RespBuyer = _RespBuyer.RespBuyerId
  association [0..1] to I_Currency      as _Currency  on $projection.CurrencyCode = _Currency.Currency
  association [0..1] to ZRK_I_SEND_VIA  as _SendVia   on $projection.SendVia = _SendVia.SendVia
  association [0..1] to zrk_i_status    as _Status    on $projection.Status = _Status.Status
{
  key doc_uuid              as DocUuid,
      object_id             as ObjectId,
      title                 as Title,
      resp_buyer            as RespBuyer,
      resp_buyer            as QvRespBuyer,
      supplier              as Supplier,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      avob                  as Avob,
      currency_code         as CurrencyCode,
      valid_from            as ValidFrom,
      valid_to              as ValidTo,
      send_via              as SendVia,
      _SendVia.SendViaT     as SendViaT,
      status                as Status,
      _Status.StatusText  as StatusText ,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,


      /* associations */
      _Plant,

      _Items,
      
      _Usage,

      _RespBuyer,
      _Supplier,
      _Currency,
      _SendVia,
      _Status
}
