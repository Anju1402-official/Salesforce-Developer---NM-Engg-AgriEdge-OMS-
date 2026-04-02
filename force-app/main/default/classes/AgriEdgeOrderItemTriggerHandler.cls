public with sharing class AgriEdgeOrderItemTriggerHandler {
    public static void afterInsert(List<AgriEdge_OrderItem__c> newItems) {
        AgriEdgeOrderManagementService.syncOrderTotalsAndInventory(newItems, null);
    }

    public static void afterUpdate(List<AgriEdge_OrderItem__c> newItems, Map<Id, AgriEdge_OrderItem__c> oldMap) {
        AgriEdgeOrderManagementService.syncOrderTotalsAndInventory(newItems, oldMap);
    }

    public static void afterDelete(Map<Id, AgriEdge_OrderItem__c> oldMap) {
        AgriEdgeOrderManagementService.syncAfterDelete(oldMap);
    }

    public static void afterUndelete(List<AgriEdge_OrderItem__c> newItems) {
        AgriEdgeOrderManagementService.syncOrderTotalsAndInventory(newItems, null);
    }
}
