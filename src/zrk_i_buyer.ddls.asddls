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
      @ObjectModel.text.element: ['LastName']

  key Customer.customer_id   as RespBuyerId,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.name.givenName: true
      Customer.first_name    as FirstName,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text: true
      @Semantics.name.fullName: true
      Customer.last_name     as LastName,

      Customer.title         as Title,

      Customer.street        as Street,

      Customer.postal_code   as PostalCode,

      Customer.city          as City,

      @Consumption.valueHelpDefinition: [{entity: { name: 'I_Country', element: 'Country' } }]
      Customer.country_code  as CountryCode,
      @Semantics.telephone.type: [#PREF]
      Customer.phone_number  as PhoneNumber,

      @Semantics.eMail.address
      Customer.email_address as EMailAddress,

      /* Associations */
      _Country

}
