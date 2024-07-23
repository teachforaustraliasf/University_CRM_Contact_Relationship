trigger MayAdditionallyTeachToText on Associate_Record__c (before insert, before update) {
 
   for (Associate_Record__c ia : Trigger.new) {
       if (ia.May_Additionally_Teach__c == null) {
           ia.May_Additionally_Teach_Text__c = '';
           }
       else {
       String[] values = ia.May_Additionally_Teach__c.split(';');
       ia.May_Additionally_Teach_Text__c = '';     
       
           for (Integer i = 0; i < values.size(); i++) {
               String value = values[i].trim();
               if (value == 'Business Management2') {
                           value = 'Business Management';
                           }
               if (value == 'Art') {
                           value = 'Visual Arts';
                           }
               if (!String.isBlank(value)) {
                   if (!String.isBlank(ia.May_Additionally_Teach_Text__c)) {
                       ia.May_Additionally_Teach_Text__c += '\n';
                   }
                   ia.May_Additionally_Teach_Text__c += value;
           }
           }
       }
   }    
}