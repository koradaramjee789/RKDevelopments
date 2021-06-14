@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for PR Item'
define view entity zrk_i_pr_item as select from zrk_a_pr_item
association to parent zrk_i_pr_head as _Head
    on $projection.HeadUuid = _Head.HeadUuid 
    {
    key item_uuid as ItemUuid,
    head_uuid as HeadUuid,
    item_no as ItemNo,
    part_no as PartNo,
    comm_code as CommCode,
    quantity as Quantity,
    unit as Unit,
    price as Price,
    currency as Currency,
    delivery_date as DeliveryDate,
    supplier as Supplier,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    local_last_changed_at as LocalLastChangedAt,
    _Head // Make association public
}
