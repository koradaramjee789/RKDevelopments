@AbapCatalog.sqlViewName: 'ZRK_ISNDVIA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for Send via'
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
@Metadata.allowExtensions: true
define view ZRK_I_SEND_VIA as select from zrk_md_send_via as SendVia
{
    @ObjectModel.text.element: ['SendViaT']
    key send_via as SendVia,
    @Search.defaultSearchElement: true
    send_via_t as SendViaT
}
