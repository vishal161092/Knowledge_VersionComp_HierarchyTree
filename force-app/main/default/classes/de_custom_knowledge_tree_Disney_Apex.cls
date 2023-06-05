public class de_custom_knowledge_tree_Disney_Apex {

    @AuraEnabled
    public static String fetchKnowledgeRecords(string parentKnowId) {
        
        String currentSelectedKnowledge = parentKnowId;

        Knowledge__kav k = [SELECT Id, Title, Language, Country__c, Top_Level_Parent__c, Review_Status__c, PublishStatus, Parent__c FROM Knowledge__kav WHERE Id =: parentKnowId];
        
        Knowledge__kav k1;
        Knowledge__kav k2;

        system.debug('parentKnowId>>> '+parentKnowId);

        Boolean boolParent;
        Boolean checkElse;

        if(k.Top_Level_Parent__c == true)
        {
                boolParent = true;
            }
        else {
            
            boolParent = false;

            k1 = [SELECT Id, Title, Language, Country__c, Top_Level_Parent__c, PublishStatus, Review_Status__c, Parent__c FROM Knowledge__kav WHERE Id =: k.Parent__c];

            if( k1.Top_Level_Parent__c == true){
                checkElse = true;
                System.debug('1st Level');
                parentKnowId = k1.Id;
            }
            else {
                checkElse = false;
                
                k2 = [SELECT Id, Title, Language, Country__c, Top_Level_Parent__c, PublishStatus, Review_Status__c, Parent__c FROM Knowledge__kav WHERE Id =: k1.Parent__c];
                
                System.debug('2nd Level');
                parentKnowId = k2.Id;
            }

        }

                List<Knowledge__kav> child1 = [SELECT Id, Title, Language, PublishStatus, Country__c, Review_Status__c, Parent__c FROM Knowledge__kav WHERE Parent__c =: parentKnowId];

                List<Id> collId = new List<Id> ();

                for (Knowledge__kav a : child1) {
                    collId.add(a.Id);
                }

                List<Knowledge__kav> child2 = [SELECT Id, Title, Language, PublishStatus, Country__c, Review_Status__c, Parent__c FROM Knowledge__kav WHERE Parent__c IN: collId];

                String child1str = '';
                String child2str = '';
                String finalstr = '';

            if(child1.size()>0) {
                for(Knowledge__kav a : child1) {
                    
                    system.debug('a>>> '+a);

                    if(child2.size()>0) {

                        for(Knowledge__kav b : child2) {
                        
                        system.debug('b>>> '+b);

                            if(a.Id == b.Parent__c){

                                if(b.Id == currentSelectedKnowledge)
                                {
                                    system.debug('In b.Id == parentKnowId');
                                    child2str = child2str + '{"items":[],"label":"' + b.Title + ' (current)","name":"' + b.Id + '","expanded":true,"metatext": "'+ b.Language +' | Status: '+ b.PublishStatus +'"},';
                                }
                                else 
                                {   system.debug('Else of In b.Id == parentKnowId');
                                    child2str = child2str + '{"items":[],"label":"' + b.Title + '","name":"' + b.Id + '","expanded":true,"metatext": "'+ b.Language +' | Status: '+ b.PublishStatus +'"},';
                                }
                            }
                        }
                    }
                    else {
                        child2str = ' ';
                    }

                    system.debug('a.Id >> '+a.Id);
                    system.debug('currentSelectedKnowledge >> '+currentSelectedKnowledge);

                    if(a.Id == currentSelectedKnowledge) 
                    {
                        system.debug('In a.Id == parentKnowId');
                        child1str = child1str + '{"items":['+ child2str.substring(0, child2str.length() - 1) +'],"label":"' + a.Title + ' (current)","name":"' + a.Id + '","expanded":true,"metatext": "'+ a.Language +' | Status: '+ a.PublishStatus +'"},';
                    }
                    else 
                    {   system.debug('Else of In a.Id == parentKnowId');
                        child1str = child1str + '{"items":['+ child2str.substring(0, child2str.length() - 1) +'],"label":"' + a.Title + '","name":"' + a.Id + '","expanded":true,"metatext": "'+ a.Language +' | Status: '+ a.PublishStatus +'"},';
                    }
                    child2str = '';
                }
            }
            else {
                        child1str = ' ';
                    }



        if(boolParent == true){
            finalstr = '[{"items":[' + child1str.substring(0, child1str.length() - 1) + '],"label":"' + k.Title + ' (current)","name":"' + k.Id + '","expanded":true,"metatext": "'+ k.Language +' | Status: '+ k.PublishStatus +'"}]';
        }
        else if(boolParent == false && checkElse == true){
            finalstr = '[{"items":[' + child1str.substring(0, child1str.length() - 1) + '],"label":"' + k1.Title + '","name":"' + k1.Id + '","expanded":true,"metatext": "'+ k1.Language +' | Status: '+ k1.PublishStatus +'"}]';
        }
        else {
            finalstr = '[{"items":[' + child1str.substring(0, child1str.length() - 1) + '],"label":"' + k2.Title + '","name":"' + k2.Id + '","expanded":true,"metatext": "'+ k2.Language +' | Status: '+ k2.PublishStatus +'"}]';
        }
        
        system.debug('finalstr@@@ '+ finalstr);

        return finalstr;

        
        //return null;    
    }

    @AuraEnabled(cacheable=true)
    public static List<Knowledge__kav> getAllKnowledgeRecords(string parentKnowId) {
        //parentKnowId = 'ka18Z0000000r86QAA';
        return [SELECT Title, Language FROM Knowledge__kav WHERE Id =: parentKnowId];
    }

    @AuraEnabled
    public static List<Knowledge__kav> getChildKnowledgeArticles(Id parentKnowId) {
        
        return [SELECT Title, Language FROM Knowledge__kav WHERE Parent__c = :parentKnowId];
    
    }

}