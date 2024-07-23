trigger QualifiedToTeachToText on Associate_Record__c (before insert, before update) {
 
   for (Associate_Record__c ia : Trigger.new) {
    if (ia.Qualified_to_Teach__c == null) {
           ia.Qualified_to_Teach_Text__c = '';
           }
       else {
       String[] values = ia.Qualified_to_Teach__c.split(';');
       ia.Qualified_to_Teach_Text__c = '';     
       
           for (Integer i = 0; i < values.size(); i++) {
               String value = values[i].trim();
               if (value == 'Business Management2') {
                           value = 'Business Management';
                           }
               if (value == 'Art') {
                           value = 'Visual Arts';
                           }
 
               if (!String.isBlank(value)) {
                   if (!String.isBlank(ia.Qualified_to_Teach_Text__c)) {
                       if (value == 'Business Management2') {
                           value = 'Business Management';
                           }
                       ia.Qualified_to_Teach_Text__c += '\n';
                   }
                   ia.Qualified_to_Teach_Text__c += value;
                   
           }
           }
       }
   }    
}