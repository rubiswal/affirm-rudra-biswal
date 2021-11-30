import { LightningElement , wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAccountList from '@salesforce/apex/AccountController.getAccountList';
import fetchAccountDetails from '@salesforce/apex/AccountController.fetchAccountDetails';


export default class LwcDemo extends NavigationMixin(LightningElement) {
    selectedLineItem;
    error;
    btnVisible = false;
    accounts;
    

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
        event.target.classList.add('highlight');;
        this.selectedLineItem = event.currentTarget.dataset.item;
        this.btnVisible = true;
    }
}