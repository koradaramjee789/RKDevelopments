@AbapCatalog.sqlViewName: 'ZRK_ICOMCODE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for Comm code'
define view zrk_i_comm_code
  as select from zrk_md_comm_code
{
      @ObjectModel.text.element: ['Description']
  key comm_code   as CommCode,
      description as Description
}
