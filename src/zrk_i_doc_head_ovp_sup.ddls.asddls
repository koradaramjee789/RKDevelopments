@AbapCatalog.sqlViewName: 'ZRK_IDHSOVSP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for document supplier overview'
define root view zrk_i_doc_head_ovp_sup
  as select from zrk_a_doc_head
   association [1] to zrk_i_supplier as _Supplier
      on $projection.SupplierId = _Supplier.SupplierId
{
  key supplier   as SupplierId,
      count( * ) as NoOfDocs,
      //    title as Title,
      //    resp_buyer as RespBuyer,

      //    avob as Avob,
      //    currency_code as CurrencyCode


      _Supplier
}
group by
  supplier
  
