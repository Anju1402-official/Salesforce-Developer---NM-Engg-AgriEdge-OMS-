public with sharing class AgriEdgeOrderManagementService {
    public static void syncOrderTotalsAndInventory(
        List<AgriEdge_OrderItem__c> newItems,
        Map<Id, AgriEdge_OrderItem__c> oldMap
    ) {
        Set<Id> orderIds = new Set<Id>();
        Map<Id, Decimal> quantityDeltaByProduct = new Map<Id, Decimal>();

        if (oldMap != null) {
            for (AgriEdge_OrderItem__c oldItem : oldMap.values()) {
                if (oldItem.Order__c != null) {
                    orderIds.add(oldItem.Order__c);
                }
                if (oldItem.Product__c != null) {
                    Decimal restoredQty = quantityDeltaByProduct.containsKey(oldItem.Product__c)
                        ? quantityDeltaByProduct.get(oldItem.Product__c)
                        : 0;
                    quantityDeltaByProduct.put(oldItem.Product__c, restoredQty + oldItem.Quantity__c);
                }
            }
        }

        for (AgriEdge_OrderItem__c item : newItems) {
            if (item.Order__c != null) {
                orderIds.add(item.Order__c);
            }
            if (item.Product__c != null) {
                Decimal consumedQty = quantityDeltaByProduct.containsKey(item.Product__c)
                    ? quantityDeltaByProduct.get(item.Product__c)
                    : 0;
                quantityDeltaByProduct.put(item.Product__c, consumedQty - item.Quantity__c);
            }
        }

        recalculateOrderTotals(orderIds);
        updateInventory(quantityDeltaByProduct);
    }

    public static void syncAfterDelete(Map<Id, AgriEdge_OrderItem__c> oldMap) {
        if (oldMap == null || oldMap.isEmpty()) {
            return;
        }

        Set<Id> orderIds = new Set<Id>();
        Map<Id, Decimal> quantityDeltaByProduct = new Map<Id, Decimal>();

        for (AgriEdge_OrderItem__c oldItem : oldMap.values()) {
            if (oldItem.Order__c != null) {
                orderIds.add(oldItem.Order__c);
            }
            if (oldItem.Product__c != null) {
                Decimal restoredQty = quantityDeltaByProduct.containsKey(oldItem.Product__c)
                    ? quantityDeltaByProduct.get(oldItem.Product__c)
                    : 0;
                quantityDeltaByProduct.put(oldItem.Product__c, restoredQty + oldItem.Quantity__c);
            }
        }

        recalculateOrderTotals(orderIds);
        updateInventory(quantityDeltaByProduct);
    }

    public static void recalculateOrderTotals(Set<Id> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) {
            return;
        }

        Map<Id, Decimal> totalsByOrder = new Map<Id, Decimal>();
        for (AggregateResult result : [
            SELECT Order__c orderId, SUM(Total_Price__c) total
            FROM AgriEdge_OrderItem__c
            WHERE Order__c IN :orderIds
            GROUP BY Order__c
        ]) {
            totalsByOrder.put((Id) result.get('orderId'), (Decimal) result.get('total'));
        }

        List<AgriEdge_Order__c> ordersToUpdate = new List<AgriEdge_Order__c>();
        for (Id orderId : orderIds) {
            ordersToUpdate.add(new AgriEdge_Order__c(
                Id = orderId,
                Total_Amount__c = totalsByOrder.containsKey(orderId) ? totalsByOrder.get(orderId) : 0
            ));
        }

        if (!ordersToUpdate.isEmpty()) {
            update ordersToUpdate;
        }
    }

    public static void updateInventory(Map<Id, Decimal> quantityDeltaByProduct) {
        if (quantityDeltaByProduct == null || quantityDeltaByProduct.isEmpty()) {
            return;
        }

        List<AgriEdge_Inventory__c> inventoryToUpdate = [
            SELECT Id, Product__c, Stock_Quantity__c
            FROM AgriEdge_Inventory__c
            WHERE Product__c IN :quantityDeltaByProduct.keySet()
        ];

        for (AgriEdge_Inventory__c inventory : inventoryToUpdate) {
            Decimal currentQty = inventory.Stock_Quantity__c == null ? 0 : inventory.Stock_Quantity__c;
            Decimal delta = quantityDeltaByProduct.get(inventory.Product__c);
            inventory.Stock_Quantity__c = currentQty + delta;
        }

        if (!inventoryToUpdate.isEmpty()) {
            update inventoryToUpdate;
        }
    }
}
