@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for PR app Tree Table'
//@ObjectModel.query.implementedBy: 'ABAP:ZRK_CL_PR_TREE'
define root view entity zrk_i_pr_tree 
    as select from zrk_a_pr_head as head
    inner join zrk_a_pr_item as item on head.head_uuid = item.head_uuid
//composition of target_data_source_name as _association_name 

{
    
   key concat_with_space(head.doc_id, item.item_no, 1) as Node,
   head.head_uuid as HeadUuid,
   head.doc_id as DocId,
   head.title as Title,
   head.resp_buyer as RespBuyer,
   head.status as Status,
   item.item_uuid as ItemUuid,
   item.item_no as ItemNo,
   item.part_no as PartNo,
   item.comm_code as CommCode,
   item.quantity as Quantity,
   item.unit as Unit,
   item.price as Price,
   item.currency as Currency,
   item.delivery_date as DeliveryDate,
   item.supplier as Supplier,
   case 
   when item.item_uuid is null
   then '0'
   else '1'
   end as HierarchyLevel,
   case 
   when item.item_uuid is null
   then '0'
   else '1'
   end as DrillState

}
