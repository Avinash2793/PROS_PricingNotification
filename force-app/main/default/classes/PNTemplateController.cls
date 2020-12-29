public with Sharing class PNTemplateController {

    @AuraEnabled 
    public static List<TemplateWrapper> fetchEmailTemplates(){
        String currentUserId = UserInfo.getUserId() ; 
        List<String> sharedTemplateIdList = getSharedTemplateIdList(currentUserId);
        List<TemplateWrapper> templateWrapperList  = new List<TemplateWrapper>();
        for(Pricing_Notification_Email_Template__c template  : [Select id,Name,RecordType.Name,Template_Content__c 
                                                                from Pricing_Notification_Email_Template__c 
                                                                where createdById = :currentUserId OR ID IN :sharedTemplateIdList]){
            TemplateWrapper tempWrap = new TemplateWrapper();
            tempWrap.templateIstance = template;
            tempWrap.templateName    = template.Name;
			tempWrap.templateContent = template.Template_Content__c;                                                                    
            tempWrap.templateType	 = template.RecordType.Name; 		    
        	templateWrapperList.add(tempWrap);     
  		}
        return templateWrapperList;
    }

  /*  @AuraEnabled 
    public static List<User> fetchUserList(String userName){
        List<User> usersList  = new List<User>();
        String nameSearch = '%'+userName+'%';
        String queryString =  'Select Id,Name,Profile.Name,ProfileId from User where Profile.Name = \'System Administrator\'';
        if(String.isNotBlank(userName)){
            queryString += 'And Name Like \''+nameSearch+'\'';
        }
        queryString += 'Order By Name';
        usersList = Database.query(queryString);
        return usersList;
    }
    @AuraEnabled 
    public static List<TemplateWrapper> searchTemplates(String templateName, String templateType){
        String currentUserId = UserInfo.getUserId() ; 
        List<String> sharedTemplateIdList = getSharedTemplateIdList(currentUserId);
        List<TemplateWrapper> templateWrapperList  = new List<TemplateWrapper>();
        
        String recrdTypeId = '';
        if(String.isNotBlank(templateType)){
	        recrdTypeId = [Select Id from RecordType where Name =: templateType].Id;
        } 
        String nameSearch = '%'+templateName+'%';
		String queryString= 'Select Id,Name,RecordType.Name,Template_Content__c from Pricing_Notification_Email_Template__c ';
        	   	
        if(sharedTemplateIdList.size() > 0){
            queryString+= 'where (createdById =\''+currentUserId+'\' OR ID IN :sharedTemplateIdList ) ';
        }else{
            queryString+= 'where createdById =\''+currentUserId+'\' ';
        }
        
        if(String.isNotBlank(templateType) && String.isNotBlank(templateName)){
            queryString += 'AND (RecordTypeId = \''+recrdTypeId+'\' OR Name Like \''+nameSearch+'\')';
        }else if(String.isNotBlank(templateType)){
            queryString += 'AND RecordTypeId = \''+recrdTypeId+'\'';
        }else if(String.isNotBlank(templateName)){
            queryString += 'AND Name Like \''+nameSearch+'\'';
        }
        
        system.debug('--> queryString  '+queryString);
        
        List<Pricing_Notification_Email_Template__c> templateList = Database.query(queryString);
        
        if(templateList.size() > 0){
            for(Pricing_Notification_Email_Template__c template : templateList){
                TemplateWrapper tempWrap = new TemplateWrapper();
                tempWrap.templateIstance = template;
                tempWrap.templateName    = template.Name;
                tempWrap.templateType	 = template.RecordType.Name; 
                tempWrap.templateContent = template.Template_Content__c;
                templateWrapperList.add(tempWrap);     
            }
        }
        return templateWrapperList;
    }
    @AuraEnabled 
    public static TemplateWrapper generateTemplates(Pricing_Notification_Email_Template__c templtDtails, String tmpltType){
        TemplateWrapper tempWrap = new TemplateWrapper();
        try{
            templtDtails.Id = null;
            templtDtails.RecordTypeId = [Select Id from RecordType where Name =: tmpltType].Id;
            system.debug('-->  templtDtails '+templtDtails);
            insert templtDtails;
            
            if(templtDtails.Id != null){
                tempWrap.templateIstance = templtDtails;
                tempWrap.templateName    = templtDtails.Name;
                tempWrap.templateType	 = tmpltType; 		    
            }            
        }Catch(Exception e){
            system.debug('Error while generating Email Templates '+e.getMessage());
        }
        return tempWrap;
    }
	@AuraEnabled
    public static void shareTemplatesApx(List<String> templateIds, List<String> userIds){
        String templateIdsStr = '';
        for (String tempId : templateIds){
            templateIdsStr += tempId+',';
        }    
        templateIdsStr = templateIdsStr.removeEnd(',');
    	List<User> userList = [Select Id,Shared_Email_Templates__c from User where Id IN :userIds];
        for(User usr : userList){
            String existingSharedTemplateIds = usr.Shared_Email_Templates__c;
            if(String.isNotBlank(existingSharedTemplateIds)){
                usr.Shared_Email_Templates__c  += ','+templateIdsStr;
            }else{
                usr.Shared_Email_Templates__c  = templateIdsStr;
            }
        }
        try{
            update userList;
        }Catch(Exception e){
            system.debug('Error while updating user list '+e.getMessage());
        }
    }
    
    @AuraEnabled 
    public static TemplateWrapper editTemplates(Pricing_Notification_Email_Template__c templtDtails, String tmpltType){
        TemplateWrapper tempWrap = new TemplateWrapper();
        try{
            templtDtails.RecordTypeId = [Select Id from RecordType where Name =: tmpltType].Id;
            system.debug('-->  templtDtails '+templtDtails);
            update templtDtails;
            
            tempWrap.templateIstance = templtDtails;
            tempWrap.templateName    = templtDtails.Name;
            tempWrap.templateType	 = tmpltType; 		    
        }Catch(Exception e){
            system.debug('Error while generating Email Templates '+e.getMessage());
        }
        return tempWrap;
    }

    @AuraEnabled 
    public static void deleteTemplates(Pricing_Notification_Email_Template__c templtDtails){
        try{
            delete templtDtails;
        }Catch(Exception e){
            system.debug('Error while generating Email Templates '+e.getMessage());
        }
    }
	*/
    private static List<String> getSharedTemplateIdList(String curntUserId){
        List<String> sharedTemplateIdList  = new List<String>();
        User currentUserDeatils = [Select Id,Shared_Email_Templates__c from User where Id =:curntUserId];
        if(String.isNotBlank(currentUserDeatils.Shared_Email_Templates__c)){
           sharedTemplateIdList = currentUserDeatils.Shared_Email_Templates__c.split(',');
        }
        return sharedTemplateIdList;
    }
	/*
    @AuraEnabled 
    public static List<String> getPricingNotificationFields(String objectName){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap();
        List<String> allFields = new List<String>();
        for(Schema.SObjectField sfield : fieldMap.Values())
        {
            schema.describefieldresult dfield = sfield.getDescribe();
            allFields.add(dfield.getname());
            //system.debug('@@@API Name : '  + dfield.getname());
            //system.debug('####Label Name : ' + dfield.getLabel ());
        }
        
        List<String> allCustomFields = new List<String>();
        system.debug('--> allFields '+JSON.serialize(allfields)); 
        for(String field : allFields){
            if(field.endsWithIgnoreCase('__c')){
                allCustomFields.add(field.removeEndIgnoreCase('__c').toUpperCase());
            }
        }
        system.debug('--> allCustomFields '+JSON.serialize(allCustomFields)); 
        return allCustomFields;
    }*/

    public class TemplateWrapper{
        @AuraEnabled 
        public Pricing_Notification_Email_Template__c templateIstance;
        @AuraEnabled 
        public String templateName;
        @AuraEnabled 
        public String templateType;
        @AuraEnabled 
        public String templateContent;
    }
}