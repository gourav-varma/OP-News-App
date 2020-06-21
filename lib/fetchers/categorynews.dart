import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newstoday_app/apikey.dart';
import 'package:newstoday_app/models/article.dart';

class CategoryNews extends ChangeNotifier {
  // final String category;
  // CategoryNews({this.category});
  List<Article> news = [];
  List<Article> articles = List<Article>();

  Future getNews(category) async {
    String url =
        'http://newsapi.org/v2/top-headlines?country=in&category=$category&language=en&pageSize=50&apiKey=$apikey';
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((index) {
        if (index['urlToImage'] != null) {
          Article article = Article(
              title: index['title'],
              urlToImage: index['urlToImage'],
              source: index['source']['name'],
              url: index['url']);
          news.add(article);
          notifyListeners();
        }
      });
    }
    print("helooo category$news");
    print("Category${news[0]}");
  }
}
