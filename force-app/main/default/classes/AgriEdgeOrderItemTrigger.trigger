trigger AgriEdgeOrderItemTrigger on AgriEdge_OrderItem__c (
    after insert,
    after update,
    after delete,
    after undelete
) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AgriEdgeOrderItemTriggerHandler.afterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            AgriEdgeOrderItemTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
            AgriEdgeOrderItemTriggerHandler.afterDelete(Trigger.oldMap);
        } else if (Trigger.isUndelete) {
            AgriEdgeOrderItemTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}
