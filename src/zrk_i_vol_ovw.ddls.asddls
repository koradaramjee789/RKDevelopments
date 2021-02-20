@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for volume overview'
define root view entity zrk_i_vol_ovw 
as select from zrk_price_det as p
inner join zrk_quant_det as q on p.part_no = q.part_no
and p.plant = q.plant
and p.valid_from = q.valid_from
and p.valid_to = q.valid_to
//composition of target_data_source_name as _association_name 
{
    
   key p.part_no as PartNo,
   key p.plant as Plant,
   key p.valid_from as ValidFrom,
   p.valid_to as ValidTo,
   p.price as Price,
   p.currency_code as CurrencyCode,
   q.quantity as Quantity,
   q.uom as Uom,
   @Aggregation.default: #SUM
   ( cast( p.price as abap.dec(13,2) ) * cast( q.quantity as abap.dec(13,3) ) ) as volume
}
