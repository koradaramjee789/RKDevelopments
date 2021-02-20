@EndUserText.label: 'Abstract entity to extend the validity'
@Metadata.allowExtensions: true
define abstract entity ZRK_A_Doc_Extend 
 // with parameters parameter_name : parameter_type 
  {
  
    @Consumption.defaultValue: '20221231'
    extend_till : /dmo/end_date;
    comments : abap.string( 300 );
    @Semantics.quantity.unitOfMeasure : 'unit'
    quantity : zrk_de_quantity;
    unit     : msehi;
}



   
    
