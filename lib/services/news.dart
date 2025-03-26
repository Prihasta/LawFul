import 'dart:convert';
import 'package:flutter_application_1/model/articleModel.dart';
import 'package:http/http.dart' as http;


class News{
  List<Articlemodel> news=[];

  Future<void> getNews()async{
    String url="https://newsapi.org/v2/top-headlines?country=us&apiKey=4ea1ae4b1f054c4ca8dc2619328f462b";
    var response= await http.get(Uri.parse(url));

    var jsonData= jsonDecode(response.body);
  
    if(jsonData['status'] == 'ok'){
      jsonData["articles"].forEach((element){
        if(element["urlToImage"]!=null && element['description']!=null){
          Articlemodel articlemodel = Articlemodel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );
          news.add(articlemodel);
        }
      });
    }
  }
}