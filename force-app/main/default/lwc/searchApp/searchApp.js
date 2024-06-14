import { LightningElement, track } from 'lwc';
import searchItems from '@salesforce/apex/SearchController.searchItems';
import { NavigationMixin } from 'lightning/navigation';

export default class SearchApp extends NavigationMixin(LightningElement) {
    @track searchTerm = '';
    @track items = [];
    @track error;

    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
        if (this.searchTerm.length >= 3) {
            this.searchItems();
        } else {
            this.items = [];
        }
    }

    searchItems() {
        searchItems({ searchTerm: this.searchTerm })
            .then(result => {
                this.items = result;
                this.error = undefined;
                console.log('Search results:', result);
            })
            .catch(error => {
                this.error = error;
                this.items = undefined;
                console.error('Error retrieving search results:', error);
            });
    }

    handleItemClick(event) {
        const itemId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: itemId,
                objectApiName: 'dmpl__SaleOrder__c', // Updated to match the Sale Order object
                actionName: 'view'
            }
        });
    }
}
