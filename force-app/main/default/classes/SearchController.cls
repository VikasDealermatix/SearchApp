public with sharing class SearchController {
    @AuraEnabled(cacheable=true)
    public static List<dmpl__Item__c> searchItems(String searchTerm) {
        String searchQuery = '%' + String.escapeSingleQuotes(searchTerm) + '%';
        String query = 'SELECT Id, Name, dmpl__ItemType__c, dmpl__ItemCode__c, dmpl__Make__c, Image_Url__c FROM dmpl__Item__c WHERE Name LIKE :searchQuery AND dmpl__Make__c = \'MeTL\'';
        return Database.query(query);
    }
}
