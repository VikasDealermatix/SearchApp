import { LightningElement, track, wire } from 'lwc';
import searchItems from '@salesforce/apex/SearchController.searchItems';
import { NavigationMixin } from 'lightning/navigation';

export default class SearchApp extends NavigationMixin(LightningElement) {
    @track searchTerm = '';
    @track items = [];
    @track dropdownOptions = [];
    @track error;

    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
        if (this.searchTerm.length >= 3) {
            this.searchItems();
        } else {
            this.items = [];
            this.dropdownOptions = [];
        }
    }

    searchItems() {
        searchItems({ searchTerm: this.searchTerm })
            .then(result => {
                this.items = result;
                this.error = undefined;
                this.dropdownOptions = this.items.map(item => {
                    let label = item.dmpl__ItemCode__c ? item.dmpl__ItemCode__c : item.Name;
                    return { label: label, value: item.Id };
                });
                console.log('Search results:', result);
            })
            .catch(error => {
                this.error = error;
                this.items = undefined;
                this.dropdownOptions = [];
                console.error('Error retrieving search results:', error);
            });
    }

    handleItemSelection(event) {
        const itemId = event.detail.value;
        let objectApiName = 'dmpl__SaleOrder__c';

        // Determine if the selected item is a Sale Order or an Item
        const selectedItem = this.items.find(item => item.Id === itemId);
        if (selectedItem && selectedItem.dmpl__ItemCode__c) {
            objectApiName = 'dmpl__Item__c';
        }

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: itemId,
                objectApiName: objectApiName,
                actionName: 'view'
            }
        });
    }
}
