@EndUserText.label: 'Projection view for PR Item'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity zrk_c_pr_item 
  as projection on zrk_i_pr_item {
    key ItemUuid,
    HeadUuid,
    ItemNo,
    PartNo,
    CommCode,
    Quantity,
    Unit,
    Price,
    Currency,
    DeliveryDate,
    Supplier,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt,
    /* Associations */
    _Head : redirected to parent ZRK_C_PR_HEAD
}
