import 'dart:convert';

import 'package:news_app/resources/article_model.dart';
import "package:http/http.dart" as http;

class ArticleList{
  List<ArticleModel> news=[];

  Future<void> getNews(String category) async{

    var url=(category=="")?Uri.parse("https://newsapi.org/v2/top-headlines?country=in&apiKey=7fe77ac176bf450fac1f2149ccd9c3e9"):Uri.parse("https://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=7fe77ac176bf450fac1f2149ccd9c3e9");

    print("Category received is $category");

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if(jsonData['status']=="ok"){
      jsonData["articles"].forEach((element){
        if(element["urlToImage"]!=null && element["description"]!=null){
          ArticleModel  articleModel = ArticleModel(
            author: element['author'],
            title: element['title'],
            desc: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
          );

          news.add(articleModel);

        }
      });
    }
    else{
      print("Error encountered 1");
    }
  }

}