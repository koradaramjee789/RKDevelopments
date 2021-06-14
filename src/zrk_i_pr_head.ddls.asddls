@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View for PR Header'
define root view entity zrk_i_pr_head as select from zrk_a_pr_head
composition [0..*] of zrk_i_pr_item as _Items 
{
    key head_uuid as HeadUuid,
    doc_id as DocId,
    title as Title,
    resp_buyer as RespBuyer,
    status as Status,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    local_last_changed_at as LocalLastChangedAt,
    _Items // Make association public
}
