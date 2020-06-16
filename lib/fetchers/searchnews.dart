import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newstoday_app/apikey.dart';
import 'package:newstoday_app/models/article.dart';

class SearchNews extends ChangeNotifier{
  List<Article> news = [];
  List<Article> articles = List<Article>();

  Future searchNews(search) async {
    String url =
        'http://newsapi.org/v2/everything?q=$search&language=en&apiKey=$apikey';

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok' && jsonData['totalResults'] != 0) {
      jsonData['articles'].forEach((index) {
        if (index['urlToImage'] != null) {
          if(jsonData['totalResults']!=0) {
          Article article = Article(
              title: index['title'],
              urlToImage: index['urlToImage'],
              publishedAt: DateTime.parse(index['publishedAt']).toString(),
              source: index['source']['name'],
              url: index['url']);
          news.add(article);
        }  
          notifyListeners();
        }
      });
    }
    print("helooo search$news");
    // print("search${news[0]}");
  }
}