import { LightningElement, api } from 'lwc';
import fetchCurrentKnowledge from '@salesforce/apex/de_custom_knowledge_version_comparison.fetchCurrentKnowledge';
import fetchKnowledgeVersions from '@salesforce/apex/de_custom_knowledge_version_comparison.fetchKnowledgeVersions';
import fetchSelectedKnowledge from '@salesforce/apex/de_custom_knowledge_version_comparison.fetchSelectedKnowledge';

export default class De_custom_knowledge_version_comparison extends LightningElement {

@api recordId;

currentKnowArtTitle;
currentKnowArtDetail;
currentKnowArtVer;

selectedKnowArtTitle;
selectedKnowArtDetail;

errorMsg;

articleVersion = [];

options;

connectedCallback() {
    console.log('RecordId > '+this.recordId);
fetchCurrentKnowledge({
        currentKnowledgeId : this.recordId,
    }).then(result =>{
        console.log('Response >>> '+JSON.stringify(result));
        this.currentKnowArtTitle = result.Title;
        this.currentKnowArtDetail = result.FAQ_Answer__c;
        this.currentKnowArtVer = result.VersionNumber;
    })
    .catch(error =>{
        this.errorMsg = error;
    })

fetchKnowledgeVersions({
        currentKnowledgeId : this.recordId,
    }).then(result =>{
        console.log('Response >>> '+result);
        this.articleVersion = JSON.parse(result);
        //console.log('@@@ '+this.articleVersion);

        this.options = [{label: 'Version 3 - de',  value: 'ka18Z000000QCsDQAW'},{label: 'Version 3 - fr',  value: 'ka18Z000000QCryQAG'},{label: 'Version 3 - en_US',  value: 'ka18Z000000QCs3QAG'},{label: 'Version 2 - en_US',  value: 'ka18Z000000QCroQAG'},{label: 'Version 2 - fr',  value: 'ka18Z000000QCrtQAG'},{label: 'Version 1 - en_US',  value: 'ka18Z000000QCrZQAW'},{label: 'Version 0 - en_US',  value: 'ka18Z000000QCshQAG'}];
    })
    .catch(error =>{
        this.errorMsg = error;
    })
}

handleChange(event) {

    console.log('@@ '+event.detail.value);

    fetchSelectedKnowledge({
        selectedKnowledgeId : event.detail.value,
    }).then(result =>{
        console.log('Response >>> '+JSON.stringify(result));
        this.selectedKnowArtTitle = result.Title;
        this.selectedKnowArtDetail = result.FAQ_Answer__c;
    })
    .catch(error =>{
        this.errorMsg = error;
    })
}

}