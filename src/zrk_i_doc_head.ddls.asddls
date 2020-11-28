@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View for document deader'

define root view entity zrk_i_doc_head
  as select from zrk_a_doc_head

  composition [0..*] of zrk_i_doc_plant as _Plant
  
  composition [0..*] of ZRK_I_DOC_ITEM as _Items
  
  association [0..1] to zrk_i_supplier as _Supplier  on $projection.Supplier = _Supplier.SupplierId
  association [0..1] to zrk_i_buyer    as _RespBuyer on $projection.RespBuyer = _RespBuyer.RespBuyerId
  association [0..1] to I_Currency     as _Currency  on $projection.CurrencyCode = _Currency.Currency
{
  key doc_uuid              as DocUuid,
      object_type           as ObjectType,
      object_id             as ObjectId,
      title                 as Title,
      resp_buyer            as RespBuyer,
      supplier              as Supplier,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      avob                  as Avob,
      currency_code         as CurrencyCode,
      valid_from            as ValidFrom,
      valid_to              as ValidTo,
      send_via              as SendVia,

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
      
      _RespBuyer,
      _Supplier,
      _Currency
}
