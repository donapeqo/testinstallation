public with sharing class CustellaCreate{
    @Future(callout=true)
    public static void AccountCallout(id recID){
        //Select record
        Account acc,accupdate;
        acc = [select id,name,phone, Default_Billing_Site__r.City__c, 
        ToLabel(Default_Billing_Site__r.Country__c),
        Default_Billing_Site__r.Zip_Postal_Code__c,
        ToLabel(Default_Billing_Site__r.States__c),
        Default_Billing_Site__r.Address_Line_1__c,   
         Industry,Fax__c,Default_Shipping_Site__r.City__c,
         ToLabel(Default_Shipping_Site__r.Country__c),
         Default_Shipping_Site__r.Zip_Postal_Code__c, 
         ToLabel(Default_Shipping_Site__r.States__c),
         Default_Shipping_Site__r.Address_Line_1__c,
         description,fax,type,website,custella_ID__c,
         Email__c from account where id = :recID]; 
        string resBody = CustellaModel.customerJSON(acc); 
          System.debug('resbody : '+resbody);
        //Connect
        string authToken = CustellaAuthenticate.connect();
        Http http = new Http(); HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Custella/api/customers');  req.setHeader('Content-Type','application/json');   req.setHeader('Authorization','Bearer '+authToken);
        string method;
        if(acc.custella_ID__c != null) method='PUT';
        else method='POST';
        req.setMethod(method);  req.setBody(resBody);
        HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest()){    res = http.send(req); resBody = res.getbody(); 
        system.debug('resBody'+res.getbody());
        //Update ID in SF
        Map <String, Object> resultObject = (Map <String, Object>)JSON.deserializeUntyped(resBody);
       Integer resID = (Integer)resultObject.get('id'); 
     //  String resID = (String)resultObject.get('id');
        System.debug('resId'+resID);accupdate = new Account();accupdate.Custella_ID__c = string.valueOf(resID); accupdate.Id=recID;
        update accupdate;
    }} 
    @Future(callout=true)
    public static void EquipmentCallout(id recID,string type){
        //Select record
        Product2 equip,equipupdate;
        equip = [select Name,toLabel(Machine_Availability__c),toLabel(Engine_Make__c),Manufacturing_year__c,toLabel(Make_Model__c),
            toLabel(Equipment_type__c), Rental_Customer__c,IsActive,Engine_number_1__c,Engine_number_2__c,Engine_model__c,custella_ID__c,CMMS_Service_Zone__c,Asset_description__c,Serial_Number__c,id,Equipment_Usage_Hours__c,toLabel(Service_Zone__c),   Equipment_Number__c, City__c, Address_Line_1__c,ToLabel(Country__c),State__c, Zip_Postal_Code__c FROM Product2 where id = :recID];       
        // Create Json
        string reqBody = '';
        if(type == 'Equipment')
            reqBody = CustellaModel.EquipmentJSON(equip,type);
        else if(type == 'Accessory')
            reqBody = CustellaModel.EquipmentJSON(equip,'Accessory');
        string resBody='';
        system.debug('reqBody ::: '+reqBody);
        //Connect to SF
        string authToken = CustellaAuthenticate.connect();
        Http http = new Http(); HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Custella/api/assets?doNOTPush=true');   req.setHeader('Content-Type','application/json');      req.setHeader('Authorization','Bearer '+authToken);
        string method;
        if(equip.custella_ID__c != null) method='PUT'; //PUT is for checking if resource exists then update
        else method='POST'; //POST is always for creating a resource
        req.setMethod(method);  req.setBody(reqBody);
        HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest()){
            res = http.send(req);   resBody = res.getbody();  system.debug('resBody::'+res.getbody()); 
        //Update ID in SF
        Map <String, Object> resultObject = (Map <String, Object>)JSON.deserializeUntyped(resBody);
        Integer resID = (Integer)resultObject.get('id');    System.debug('resId'+resID);
        equipupdate = new Product2();
        equipupdate.Id=recID;  
        equipupdate.Custella_ID__c = string.valueOf(resID);
        System.debug('equipupdate::'+equipupdate);
        update equipupdate;
       } 
    }
    @Future(callout=true)
    public static void ProductCallout(id recID,string type){
        //Select record
        Product2 sPart;
        sPart = [select Name,Asset_description__c,Display_Name_Code__c,Price__c,IsActive, Product_Type__c,Units_Type__c,custella_ID__c,Make_Model__c,group__c    FROM Product2 where id = :recID];
        // Create Json
        string reqBody = '';
        if(type == 'Parts')
            reqBody = CustellaModel.SparePartsJSON(sPart,'Parts');
        else if(type == 'Service')
            reqBody = CustellaModel.SparePartsJSON(sPart,'Service');
        string resBody = '';
        system.debug('reqBody ::: '+reqBody);
        //Connect to SF
        string authToken = CustellaAuthenticate.connect();
        Http http = new Http();   HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Custella/api/products');     req.setHeader('Content-Type','application/json');      req.setHeader('Authorization','Bearer '+authToken);
        string method;
        if(sPart.custella_ID__c != null) method='PUT';
        else method='POST';
        req.setMethod('PUT'); req.setBody(reqBody);
        HttpResponse res = new HttpResponse();  
        if(!Test.isRunningTest()){
            res = http.send(req);  resBody = res.getbody();     system.debug('resBody'+res.getbody());   
        //Update ID in SF
        Map <String, Object> resultObject = (Map <String, Object>)JSON.deserializeUntyped(resBody);
        Integer resID = (Integer)resultObject.get('id'); System.debug('resId'+resID); sPart.Custella_ID__c = string.valueOf(resID);
        update sPart;
        }
    }
    @Future(callout=true)
    public static void IQCCallout(id recID){
        //Select record
        Asset iqc,asstupdate;
        iqc = [SELECT id,ToLabel(Service_Zone__c),AccountId,Product2Id,Location__c,Breakdown_Service_ID__c,custella_ID__c,Asset_Location__c FROM Asset where id =:recID];
        // Create Json
        string reqBody = ''; string resBody = '';
        reqBody = CustellaModel.iqcJSON(iqc);
        system.debug('reqBody ::: '+reqBody);
        //Connect to SF
        string authToken = CustellaAuthenticate.connect();
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://build.custella.com:8080/api/v1/record-data/iqc');   req.setHeader('Content-Type','application/json');    req.setHeader('Authorization','Bearer '+authToken); 
      //  req.setEndpoint('https://beta-node.custella.com:3000/api/v1/record-data/iqc');   req.setHeader('Content-Type','application/json');    req.setHeader('Authorization','Bearer '+authToken);
        string method;
        req.setMethod('POST'); req.setBody(reqBody);
        HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest()){       res = http.send(req); resBody = res.getbody();   system.debug('resBody'+res.getbody());     
        //Update ID in SF
        Map <String, Object> resultObject = (Map <String, Object>)JSON.deserializeUntyped(resBody);
        Integer resID = (Integer)resultObject.get('id');  System.debug('resId'+resID);  asstupdate = new Asset();
        asstupdate.Custella_ID__c = string.valueOf(resID); asstupdate.Id=recID;
        update asstupdate;    }
        
       // iqc.Custella_ID__c = string.valueOf(resID);
       // update iqc;
    }
    @Future(callout=true)
    public static void AdjustInventoryCallout(id recID){
        //Select record
        Bin_transfer__c bTransfer;
        bTransfer =[SELECT id,Name,Note__c,CreatedDate,To_Bin__r.Location_Netsuite_ID__c,To_Bin__r.Bin_Netsuite_ID__c,Product_Transfer__r.id,Quantity__c,custella_ID__c,From_Bin__r.Bin_Netsuite_ID__c  from Bin_transfer__c where id = :recID]; 
        // Create Json
        string reqBody = '';  string callURL = '';
        if(bTransfer.From_Bin__c != null){
            reqBody = CustellaModel.binTransferJSON(bTransfer);   callURL = 'callout:Custella/api/bin-transfers';
        }
        else if(bTransfer.From_Bin__c == null){
            reqBody = CustellaModel.adjInvJSON(bTransfer);   callURL = 'callout:Custella/api/inventories/adjust';
        }
        string resBody = '';
        system.debug('reqBody ::: '+reqBody);
        //Connect to SF
        string authToken = CustellaAuthenticate.connect();
        Http http = new Http();  
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint(callURL);
        req.setHeader('Content-Type','application/json');  
        req.setHeader('Authorization','Bearer '+authToken);     req.setMethod('POST');  req.setBody(reqBody);
        HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest()){   res = http.send(req); resBody = res.getbody(); 
        system.debug('resBody'+res.getbody());
        //Update ID in SF
        Map <String, Object> resultObject = (Map <String, Object>)JSON.deserializeUntyped(resBody);
        Integer resID;  string resMessage;
        if(bTransfer.From_Bin__c != null){  resID = (Integer)resultObject.get('id');  System.debug('resId'+resID);  bTransfer.Custella_ID__c = string.valueOf(resID);
            update bTransfer; }
        else if(bTransfer.From_Bin__c == null){  resMessage = (String)resultObject.get('message');  System.debug('resId'+resID);   bTransfer.Custella_ID__c = string.valueOf(resID);
            update bTransfer;}}
    }
    @Future(callout=true)
    public static void ContractCallout(id recID){
        //Select record
        OrderItem oItem ;  Order ord;
        List<OrderItem> orderItems;
        oItem = [Select id,Order.Custella_id__c,Equipment_Rental__c  from OrderItem where id =: recID];
        ord = [Select id,Name,custella_ID__c,AccountId,Shepherd_Rental_End_Date__c,Shepherd_Rental_Start_Date__c from Order where id =: oItem.OrderID];
        orderItems = [Select id,Order.Custella_id__c,Equipment_Rental__c,Equipment_Rental__r.id, Equipment_Rental__r.Serial_Number__c,Quantity, Shepherd_Rental_Start_Date__c ,Shepherd_Rental_End_Date__c  from OrderItem where OrderID =: oItem.OrderID and Equipment_Rental__c!=null];
        string resBody = CustellaModel.contractJSON(oItem,ord,orderItems);
        System.debug('resbody : '+resbody);
        //Connect
        string authToken = CustellaAuthenticate.connect();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Custella/api/contracts');    
        req.setHeader('Content-Type','application/json');    
        req.setHeader('Authorization','Bearer '+authToken);
        string method;  method='POST';
        req.setMethod(method); req.setBody(resBody);
        HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest()){    res = http.send(req); resBody = res.getbody();  system.debug('resBody'+res.getbody());
        //Update ID in SF
        Map <String, Object> resultObject = (Map <String, Object>)JSON.deserializeUntyped(resBody);
        Integer resID = (Integer)resultObject.get('id');  System.debug('resId'+resID);  ord.Custella_ID__c = string.valueOf(resID);
        update ord;     } 
    }
    @Future(callout=true)
    public static void JOStatusCallout(id recID){
        //Select record     
       /* Order ord;
        ord = [Select id,Name,custella_ID__c,IQC_SWO__c
            from Order where id =: recID];*/
        Quote Qrec;
        Qrec = [Select id,Name, Custella_SWO_Id__c from Quote where id =: recID];
        //String endURL = 'callout:Custella/api/job-orders/change-status/'+ord.IQC_SWO__c+'/to-status/PENDING';
        String endURL = 'callout:Custella/api/job-orders/change-status/'+Qrec.Custella_SWO_Id__c+'/to-status/PENDING';
        String resBody = '';
        //Connect
        string authToken = CustellaAuthenticate.connect();
        Http http = new Http(); 
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint(endURL);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization','Bearer '+authToken);
        string method;
        method='POST';
        req.setMethod(method); req.setBody(resBody);
        HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest()){   res = http.send(req); resBody = res.getbody();  system.debug('resBody'+res.getbody());
        //Update ID in SF
        Map <String, Object> resultObject = (Map <String, Object>)JSON.deserializeUntyped(resBody);
        Integer resID = (Integer)resultObject.get('id');  System.debug('resId'+resID); Qrec.Custella_ID__c = string.valueOf(resID);
        update Qrec;     }
    } 
    
    @Future(callout=true)
   public static void EquipmentHourmeterCallout(id recID){
        //Select record
        Product2 EquipmentProd;
        EquipmentProd =[SELECT id, Equipment_Usage_Hours__c ,ToLabel(Machine_Availability__c),ToLabel(Service_Zone__c), Internal_ID__c from Product2 where id = :recID]; 
        // Create Json
        string reqBody = '';  string resBody = '';  system.debug('reqBody ::: '+reqBody);
        if(EquipmentProd.Internal_ID__c !=null){
        reqBody=CustellaModel.EuipmentJSONNS(EquipmentProd);
        }
        //Connect to NS
        if(!Test.isRunningTest()){       if(EquipmentProd.Internal_ID__c !=null){ resBody = NSIntegrationUtil.newAuthorization('NetsuiteTest',reqBody,'Equip');  }   system.debug('resBody'+resBody);
        //Update ID in SF
        Map <String, Object> resultObject = (Map <String, Object>)JSON.deserializeUntyped(resBody);
        String resID;   string resMessage;
        if(EquipmentProd.Internal_ID__c!=null)     {   resMessage = (String)resultObject.get('status');
            System.debug('status'+resMessage); resID = (string)resultObject.get('equipmentid');    System.debug('bintransferid'+resID); EquipmentProd.Internal_ID__c = string.valueOf(resID);
            update EquipmentProd;    }
           
   } 
}

}