@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for document items'
define view entity ZRK_I_DOC_ITEM
  as select from zrk_a_doc_item
  association        to parent zrk_i_doc_head as _Head       on $projection.DocUuid = _Head.DocUuid
  composition [0..*] of zrk_i_item_cond       as _Conds
  association [0..1] to zrk_i_comm_code       as _MdCommCode on $projection.CommCode = _MdCommCode.CommCode
  association [0..1] to zrk_i_unit            as _MdUnit     on $projection.Unit = _MdUnit.UnitOfMeasure


{

  key      item_uuid             as ItemUuid,
  key      doc_uuid              as DocUuid,
           item_no               as ItemNo,
           part_no               as PartNo,
           comm_code             as CommCode,
           //         _MdCommCode.Description as CommCodeDesc,
           quantity              as Quantity,
           unit                  as Unit,
           @Semantics.amount.currencyCode: 'Currency'
           price                 as Price,
           currency              as Currency,
           valid_from            as ValidFrom,
           valid_to              as ValidTo,
           created_by            as CreatedBy,
           last_changed_by       as LastChangedBy,
           @Semantics.systemDateTime.localInstanceLastChangedAt: true
           local_last_changed_at as LocalLastChangedAt,


           _Head,

           _Conds,
           _MdCommCode,
           _MdUnit
}
