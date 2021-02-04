@AbapCatalog.sqlViewName: 'ZRK_IUSAGE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for Usage'
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
@Metadata.allowExtensions: true
define view ZRK_I_USAGE as select from zrk_md_usage as Usage
{
    @ObjectModel.text.element: ['Description']
    key usage_id as UsageId,
    @Search.defaultSearchElement: true
  key  description as Description
}
