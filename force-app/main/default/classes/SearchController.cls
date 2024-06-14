public with sharing class SearchController {
    @AuraEnabled(cacheable=true)
    public static List<dmpl__SaleOrder__c> searchItems(String searchTerm) {
        // Escape single quotes in search term to prevent SOQL injection
        String searchQuery = '%' + String.escapeSingleQuotes(searchTerm) + '%';
        
        // Construct the SOQL query
        String query = 'SELECT Id, ' +
                       'Name, ' +
                       'dmpl__DocumentDate__c, ' + 
                       'dmpl__PartnerAccountId__r.Name, ' +
                       'dmpl__BranchId__r.Name, ' +
                       'dmpl__Status__c, ' +
                       'dmpl__TotalOrderAmount__c ' +
                       'FROM dmpl__SaleOrder__c ' +
                       'WHERE Name LIKE :searchQuery';
        // Execute the query and return results
        return Database.query(query);
    }
}