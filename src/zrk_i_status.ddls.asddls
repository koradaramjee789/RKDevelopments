@AbapCatalog.sqlViewName: 'ZRK_ISTATUS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for Status'
define view zrk_i_status as select from zrk_md_status {
    key status as Status,
    status_text as StatusText,
    status_color as StatusColor
}
