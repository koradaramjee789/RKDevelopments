@EndUserText.label: 'projection for volume overview'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZRK_C_VOL_OVW as projection on zrk_i_vol_ovw {
    key PartNo,
    key Plant,
    key ValidFrom,
     ValidTo,
    Price,
    @Semantics.currencyCode: true
    CurrencyCode,
    @Semantics.quantity.unitOfMeasure: 'Uom'
    Quantity,
    @Semantics.unitOfMeasure: true
    Uom,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    volume
}
