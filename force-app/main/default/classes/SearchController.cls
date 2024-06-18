public with sharing class SearchController {
    @AuraEnabled(cacheable=true)
    public static List<sObject> searchItems(String searchTerm) {
        // Escape single quotes in search term to prevent SOQL injection
        String searchQuery = '%' + String.escapeSingleQuotes(searchTerm) + '%';
        
        // Query Sale Orders
        String saleOrderQuery = 'SELECT Id, ' +
                                'Name, ' +
                                'dmpl__DocumentDate__c, ' + 
                                'dmpl__PartnerAccountId__r.Name, ' +
                                'dmpl__BranchId__r.Name, ' +
                                'dmpl__Status__c, ' +
                                'dmpl__TotalOrderAmount__c ' +
                                'FROM dmpl__SaleOrder__c ' +
                                'WHERE Name LIKE :searchQuery';

        List<dmpl__SaleOrder__c> saleOrders = Database.query(saleOrderQuery);

        // Query Items
        String itemsQuery = 'SELECT Id, ' +
                            'Name, ' +
                            'dmpl__ItemType__c, ' +
                            'dmpl__ItemCode__c, ' +
                            'dmpl__Make__c ' +
                            'FROM dmpl__Item__c ' +
                            'WHERE Name LIKE :searchQuery AND dmpl__Make__c = \'MeTL\'';

        List<dmpl__Item__c> items = Database.query(itemsQuery);

        // Combine results
        List<sObject> results = new List<sObject>();
        results.addAll(saleOrders);
        results.addAll(items);

        return results;
    }
}
