@AbapCatalog.sqlViewName: 'ZRK_IUNIT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for Unit'
define view zrk_i_unit as select from I_UnitOfMeasureText {
    key UnitOfMeasure,
    UnitOfMeasureLongName,
    UnitOfMeasureName,
    UnitOfMeasureTechnicalName,
    UnitOfMeasure_E,
    UnitOfMeasureCommercialName
    /* Associations */

}
where Language = $session.system_language
