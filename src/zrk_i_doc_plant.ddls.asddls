@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for document plants'

define view entity zrk_i_doc_plant
  as select from zrk_a_doc_plant as Plant
  association        to parent zrk_i_doc_head as _Head    on $projection.DocUuid = _Head.DocUuid

  association [1..1] to zrk_i_plant           as _PlantDt on $projection.PlantId = _PlantDt.PlantId


{
  key plant_uuid            as PlantUuid,
      doc_uuid              as DocUuid,
      plant_id              as PlantId,
      trns_term             as TrnsTerm,
      trns_city             as TrnsCity,
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


      _Head,
      _PlantDt

}
