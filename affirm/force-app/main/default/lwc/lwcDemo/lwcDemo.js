import { LightningElement , wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAccountList from '@salesforce/apex/AccountController.getAccountList';
import fetchAccountDetails from '@salesforce/apex/AccountController.fetchAccountDetails';


export default class LwcDemo extends NavigationMixin(LightningElement) {
    selectedLineItem;
    error;
    btnVisible = false;
    accounts;
    activeRow = null;
    

    @wire(getAccountList)
    wiredRecord({error, data}) {
        if (error) {
            alert(error);
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message;
            }
            this.accounts = undefined;
        } else if (data) {
            this.accounts = data;
        }
    } 
    handleNavigate(event) {
        fetchAccountDetails({ acctId: this.selectedLineItem})
            .then(result => {
                const acctRec = result;
                var compDefinition = {
                    componentDef: "c:showAccountDetail",
                    attributes: {
                        accountRecord: acctRec
                    }
                };
                // Base64 encode the compDefinition JS object
                var encodedCompDef = btoa(JSON.stringify(compDefinition));
                window.location.assign('/one/one.app#' + encodedCompDef);
            })
            .catch(error => {
                this.error = error;
            });  
    }

    addColor(event) {
        const isRefresh = true;
        this.selectedLineItem = event.currentTarget.dataset.item;
        var row = this.template.querySelector(`[data-item="${this.selectedLineItem}"]`);
        if(this.activeRow == null) {
            this.activeRow = this.template.querySelector(`[data-item="${this.selectedLineItem}"]`);
        }
        if(row != this.activeRow){
            row.className='rowhighlight';
            this.activeRow.className = '';
        }
        this.btnVisible = true;
        this.activeRow = this.template.querySelector(`[data-item="${this.selectedLineItem}"]`);
    }
    
}