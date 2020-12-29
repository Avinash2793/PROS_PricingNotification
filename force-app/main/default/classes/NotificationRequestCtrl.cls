public class NotificationRequestCtrl {
    
    @AuraEnabled 
    public static List<PROS_Pricing_Notification__c> fetchPricingNotifications(SearchWrapper wraperInst){
        system.debug('--> wraperInst '+wraperInst);
        String queryString = 'SELECT Id, Name, PROS_CUSTOMER_GRN__c, DELIVERY_POINT__c, CUSTOMER_GRN__c, PRODUCT__c FROM PROS_Pricing_Notification__c ';
        if(String.isNotBlank(wraperInst.notifcnName)){
            queryString += 'where Name= \''+wraperInst.notifcnName+'\'';
        }else if(String.isNotBlank(wraperInst.cusGRN)){
            queryString += 'where PROS_CUSTOMER_GRN__c= \''+wraperInst.cusGRN+'\'';
        }else if(String.isNotBlank(wraperInst.point)){
            queryString += 'where DELIVERY_POINT__c= \''+wraperInst.point+'\'';
        }else if(String.isNotBlank(wraperInst.prodct)){
            queryString += 'where PRODUCT__c= \''+wraperInst.prodct+'\'';
        }
 		List<PROS_Pricing_Notification__c> notificationList = new List<PROS_Pricing_Notification__c>();
        notificationList = Database.query(queryString);
        return notificationList;
    }
    
    public Class SearchWrapper{
        @AuraEnabled
        public String notifcnName{get;set;}
        @AuraEnabled
        public String cusGRN{get;set;}
        @AuraEnabled
        public String point{get;set;}
        @AuraEnabled
        public String prodct{get;set;} 
    }
}