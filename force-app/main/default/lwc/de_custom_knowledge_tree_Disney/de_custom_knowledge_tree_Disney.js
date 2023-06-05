import { LightningElement, api, wire } from 'lwc';
import fetchKnowledgeRecords from '@salesforce/apex/de_custom_knowledge_tree_Disney_Apex.fetchKnowledgeRecords';
import getAllKnowledgeRecords from '@salesforce/apex/de_custom_knowledge_tree_Disney_Apex.getAllKnowledgeRecords';
import getChildKnowledgeArticles from '@salesforce/apex/de_custom_knowledge_tree_Disney_Apex.getChildKnowledgeArticles';
import { NavigationMixin } from "lightning/navigation";

export default class De_custom_knowledge_tree_Disney extends NavigationMixin(LightningElement) {

@api recordId;
errorMsg;

checkitems = [];
// updatedCheckitems = [];
// updatedCheckitems2 = [];

// mainArticle = true;
// level1Check = false;
// level2Check = false;

// chilvals = [];
selectedItemValue;
recordPageUrl;

connectedCallback() {
    console.log('>> '+this.recordId);

    fetchKnowledgeRecords({
            parentKnowId : this.recordId,
        }).then(result =>{
            console.log('Response >>> '+result);
            this.checkitems = JSON.parse(result);
            console.log('New Response >>> '+this.checkitems);
        })
        .catch(error =>{
            this.errorMsg = error;
        })

    // getAllKnowledgeRecords({
    //         parentKnowId: this.recordId
    //     }).then(result =>{
            
    //         this.checkitems = result.map((article) => ({
    //             items: [], label: article.Title, name: article.Id, expanded: true,
    //             ...article,
    //            //d ParentAccountName: account.Parent?.Name
    //         }));
            
    //         console.log(">>>"+JSON.stringify(this.checkitems));

    //     })
    //     .catch(error =>{
    //         this.errorMsg = error;
    //     })

    }

handleOnselect(event){
    
    console.log(event.detail.name);
    
   // eval("$A.get('e.force:refreshView').fire();");

   // window.open('https://artdcsdodemo.lightning.force.com/lightning/r/Knowledge__kav/'+ event.detail.name +'/view');

    this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.name,
                objectApiName: 'Knowledge__kav',
                actionName: 'view'
            },
        });
}

}