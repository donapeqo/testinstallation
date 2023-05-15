public with sharing class newsAPIController {
    @auraEnabled
    public static Map<String, Object> requestApi(String category) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://newsapi.org/v2/top-headlines?country=my&category='+category+'&apiKey=cb4c853b9b01467d947cac92538bc410');
    system.debug('Category' + category);
    req.setMethod('GET');

    Map<String, Object> newsJsonData = new Map<String,Object>();
    String strResponse = null;

    try{
        Http http =  new Http();
        HttpResponse httpResponse = http.send(req);
        if(httpResponse.getStatusCode() == 200){
            strResponse = httpResponse.getBody();
        } else {
            throw new CalloutException(httpResponse.getBody()); 
        }
    } catch (Exception e){
        throw e;
    }

    if(!String.isBlank(strResponse)){
        newsJsonData = (Map<String, Object>)JSON.deserializeUntyped(strResponse);
    }
    if(!newsJsonData.isEmpty()){
        return newsJsonData;
    }else {
        return null;
    }






    }
}