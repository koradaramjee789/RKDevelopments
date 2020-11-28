@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for document items'
define view entity ZRK_I_DOC_ITEM
  as select from zrk_a_doc_item
  association to parent zrk_i_doc_head as _Head on $projection.DocUuid = _Head.DocUuid

{
  key item_uuid             as ItemUuid,
      doc_uuid              as DocUuid,
      item_no               as ItemNo,
      part_no               as PartNo,
      comm_code             as CommCode,
      quantity              as Quantity,
      unit                  as Unit,
      price                 as Price,
      currency              as Currency,
      created_by            as CreatedBy,
      last_changed_by       as LastChangedBy,
      local_last_changed_at as LocalLastChangedAt,


      _Head
}
