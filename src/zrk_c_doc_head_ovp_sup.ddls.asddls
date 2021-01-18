@EndUserText.label: 'Top suppliers'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity zrk_c_doc_head_ovp_sup 
    as projection on zrk_i_doc_head_ovp_sup 
    { 
    @ObjectModel.text.element: [ 'SupplierName' ]
    key SupplierId,
    NoOfDocs,
    /* Associations */
    _Supplier.Name as SupplierName
    }
