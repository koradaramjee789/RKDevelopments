@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Document item conditions'
define view entity zrk_i_item_cond
  as select from zrk_a_item_cond as Cond

  association        to parent ZRK_I_DOC_ITEM as _Items on  $projection.ItemUuid = _Items.ItemUuid
                                                         and $projection.DocUuid = _Items.DocUuid
                                                         
        
  association [1..1] to zrk_i_doc_head        as _Head  on  $projection.DocUuid = _Head.DocUuid


{
  key cond_uuid             as CondUuid,
      item_uuid             as ItemUuid,
      doc_uuid              as DocUuid,
      cond_type             as CondType,
      price                 as Price,
      currency              as Currency,
      valid_from            as ValidFrom,
      valid_to              as ValidTo,
      created_by            as CreatedBy,
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Head,
      _Items


}
