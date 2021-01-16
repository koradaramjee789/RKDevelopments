@AbapCatalog.sqlViewName: 'ZRK_ISTATUS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for Status'
@ObjectModel.resultSet.sizeCategory: #XS
@Metadata.allowExtensions: true
@Search.searchable: true
define view zrk_i_status as select from zrk_md_status {
    @ObjectModel.text.element: ['StatusText']
    key status as Status,
    @Search.defaultSearchElement: true
    status_text as StatusText,
    status_color as StatusColor
}
