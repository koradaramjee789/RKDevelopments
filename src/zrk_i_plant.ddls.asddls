@AbapCatalog.sqlViewName: 'ZRK_IPLANT_RE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for plant'
@Search.searchable: true
define view zrk_i_plant
  as select from zrk_md_plant
{

  key plant_id as PlantId,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold : 0.8
      @Search.ranking : #HIGH
      name     as Name
}
