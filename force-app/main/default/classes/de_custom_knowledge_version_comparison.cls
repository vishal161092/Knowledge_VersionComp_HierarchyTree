public class de_custom_knowledge_version_comparison {

    @AuraEnabled
    public static Knowledge__kav fetchCurrentKnowledge(String currentKnowledgeId) {
        return [SELECT Title, FAQ_Answer__c, VersionNumber FROM Knowledge__kav WHERE Id =: currentKnowledgeId];
    }

    @AuraEnabled
    public static Knowledge__kav fetchSelectedKnowledge(String selectedKnowledgeId) {
        return [SELECT Title, FAQ_Answer__c FROM Knowledge__kav WHERE Id =: selectedKnowledgeId];
    }

    @AuraEnabled
    public static String fetchKnowledgeVersions(String currentKnowledgeId) {

        List<Knowledge__VersionHistory> ver = [SELECT Id, Parentid, Language FROM Knowledge__VersionHistory WHERE VersionId =: currentKnowledgeId];

        List<Knowledge__VersionHistory> verList = [SELECT Id, VersionId, EventType, Version.Title, VersionNumber, Language, ParentId FROM Knowledge__VersionHistory WHERE ParentId =: ver[0].ParentId AND VersionId!=null AND (EventType = 'KavArchived' OR EventType = 'locked') AND Language =: ver[0].Language Order By VersionNumber DESC];

        Set<String> artString = new Set<String>();

        for(Knowledge__VersionHistory v : verList){
            
            artString.add(v.VersionId);

        }

       // List<String> verHistory = new List<String>();

        String verHistory = '';

        for(String s : artString) {

            for(Knowledge__VersionHistory v : verList) {

                if(v.VersionId == s){

                    verHistory = verHistory + ('{"label": "Version ' + v.VersionNumber + ' - ' + v.Language +'",  "value": "' + v.VersionId + '"},');

                }

            }
            
        } 


        system.debug('>> '+ verHistory);

        String finalStr = '['+verHistory.substring(0, verHistory.length() - 1)+']';
String s = '[{"label": "Version 3 - de",  "value": "ka18Z000000QCsDQAW"},{"label": "Version 3 - fr",  "value": "ka18Z000000QCryQAG"}]';

system.debug('s>> '+ s);
system.debug('finalStr>> '+ finalStr);

        return finalStr;
//return s;
    }

}