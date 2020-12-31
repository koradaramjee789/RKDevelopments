@EndUserText.label: 'Abstract entity to extend the validity'
@Metadata.allowExtensions: true
define abstract entity ZRK_A_Doc_Extend 
 // with parameters parameter_name : parameter_type 
  {
    extend_till : /dmo/end_date;
    comments : abap.string( 300 );
    
}
