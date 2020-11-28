
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for document plants'

define view entity zrk_i_doc_plant 
   as select from zrk_a_doc_plant as Plant
   association to parent zrk_i_doc_head as _Head 
    on $projection.DocUuid = _Head.DocUuid
    
   association [1..1] to zrk_i_plant as _PlantDt
    on  $projection.PlantId = _PlantDt.PlantId 
    
   
   {
    key plant_uuid as PlantUuid,
    doc_uuid as DocUuid,
    plant_id as PlantId,
    trns_term as TrnsTerm,
    trns_city as TrnsCity,
    
    _Head,
    _PlantDt
    
}
