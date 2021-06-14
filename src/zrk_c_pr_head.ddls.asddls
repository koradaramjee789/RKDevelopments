@EndUserText.label: 'Projection view for PR Head'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZRK_C_PR_HEAD 
    as projection on zrk_i_pr_head {
    key HeadUuid,
    DocId,
    Title,
    RespBuyer,
    Status,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt,
    /* Associations */
    _Items : redirected to composition child zrk_c_pr_item
}
