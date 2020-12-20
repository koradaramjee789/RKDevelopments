@EndUserText.label: 'projection for document plants'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZRK_C_DOC_PLANT
  as projection on zrk_i_doc_plant
{
  key PlantUuid,
      DocUuid,
      @Consumption.valueHelpDefinition: [{ entity: {
          name: 'zrk_i_plant',
          element: 'PlantId'
      }
//      ,
//      additionalBinding: [{ localElement: 'Name', element: 'Name' }] 
      }]
      
      @ObjectModel.text.element: ['Name']
      PlantId,   
      _PlantDt.Name as Name,
      TrnsTerm,
      TrnsCity,
      /* Associations */
      _Head : redirected to parent zrk_c_doc_head,
      _PlantDt
}
