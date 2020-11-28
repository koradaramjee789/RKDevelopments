@AbapCatalog.sqlViewName: 'ZRK_ISUPP_RE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier View - CDS Data Model'

@Search.searchable: true

define view zrk_i_supplier
  as select from zrk_supplier as Supplier

  association [0..1] to I_Country as _Country on $projection.CountryCode = _Country.Country

{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['Name']
  key Supplier.supplier_id     as SupplierId,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text: true
      Supplier.name          as Name,

      Supplier.street        as Street,

      Supplier.postal_code   as PostalCode,

      Supplier.city          as City,

      @Consumption.valueHelpDefinition: [{entity: { name: 'I_Country', element: 'Country' } }]
      Supplier.country_code  as CountryCode,

      Supplier.phone_number  as PhoneNumber,

      Supplier.email_address as EMailAddress,

      Supplier.web_address   as WebAddress,

      /* Associations */
      _Country
}
