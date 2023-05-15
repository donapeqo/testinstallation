import { LightningElement, track, api, wire } from 'lwc';
import getArticleMap from '@salesforce/apex/newsAPIController.requestApi';

export default class NewsAPIComponent extends LightningElement {

@track result = [];
@track value = 'business';

get options() {
    return [
        { label: 'Business', value: 'business' },
        { label: 'Entertainment', value: 'entertainment' },
        { label: 'Health', value: 'health' },
        { label: 'Science', value: 'science' },
        { label: 'Sports', value: 'sports' },
        { label: 'Technology', value: 'technology' },
       
    ];
}

    



handleChange(event){
    this.value = event.detail.value;
    this.getArticleMap();
}

connectedCallback(){
    this.getArticleMap();
}

getArticleMap(){
    getArticleMap({category: this.value})
    .then(response=>{
        console.log(response);
        this.formatNewsData(response.articles)
    })
}

formatNewsData(res){
    this.result = res.map((item,index)=>{
        let id = `new_${index+1}`;
        let date = new Date(item.publishedAt).toDateString()
        let name = item.source.name;
        return { ...item, id: id, name: name, date: date}
    })
}



}