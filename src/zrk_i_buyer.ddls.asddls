@AbapCatalog.sqlViewName: 'ZRK_IBUYER_RE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer View - CDS Data Model'

@Search.searchable: true

@ObjectModel: {
    representativeKey: 'RespBuyerId'
}
define view zrk_i_buyer
  as select from /dmo/customer as Customer

  association [0..1] to I_Country as _Country on $projection.CountryCode = _Country.Country

{
      @ObjectModel.text.element: ['FullName']

  key Customer.customer_id   as RespBuyerId,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.name.givenName: true
      Customer.first_name    as FirstName,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text: true
      @Semantics.name.fullName: true
      concat_with_space(Customer.first_name, Customer.last_name, 1)   as FullName,
      @Semantics.name.familyName: true 
      Customer.last_name     as LastName,
      
      @Semantics.name.prefix: true
      Customer.title         as Title,
      
      @Semantics.address.street: true
      Customer.street        as Street,
      
      @Semantics.address.zipCode: true
      Customer.postal_code   as PostalCode,
      
      @Semantics.address.city: true
      Customer.city          as City,

      @Consumption.valueHelpDefinition: [{entity: { name: 'I_Country', element: 'Country' } }]
      @Semantics.address.country: true
      Customer.country_code  as CountryCode,
      @Semantics.telephone.type: [#PREF]
      Customer.phone_number  as PhoneNumber,

      @Semantics.eMail.address
      @Semantics:{ eMail.type:  [ #WORK ] }
      Customer.email_address as EMailAddress,

      /* Associations */
      _Country

}
