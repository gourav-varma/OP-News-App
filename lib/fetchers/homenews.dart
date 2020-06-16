import 'package:newstoday_app/apikey.dart';
import 'package:newstoday_app/models/article.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class News {
  List<Article> news = [];
  // List<Article> scrollNews = [];

  Future getNews() async {
    String url =
        'http://newsapi.org/v2/top-headlines?language=en&pageSize=50&apiKey=$apikey';
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((index) {
        if (index['urlToImage'] != null) {
          Article article = Article(
              title: index['title'],
              urlToImage: index['urlToImage'],
              url: index['url']);
          news.add(article);
        }
      });
    }
    print("helooo$news");
    print(news[0]);
  }

  // Future getScrollNews() async {
  //   String url =
  //       'https://newsapi.org/v2/top-headlines?country=in&language=en&apiKey=735cc320becd484aa694419ee3ab8e3d';
  //   var response = await http.get(url);
  //   var jsonData = jsonDecode(response.body);

  //   if (jsonData['status'] == 'ok') {
  //     jsonData['articles'].forEach((index) {
  //       if (index['urlToImage'] != null) {
  //         Article article = Article(
  //             title: index['title'],
  //             urlToImage: index['urlToImage'],
  //             publishedAt: DateTime.parse(index['publishedAt']).toString(),
  //             source: index['source']['name'],
  //             url: index['url']);
  //         scrollNews.add(article);
  //       }
  //     });
  //   }
  // print("this is scroll news$scrollNews");
  // print("helooo$news");
  // print(news[0]);
  // }
}

class ScrollNews {
  List<Article> scrollNews = [];
  Future getScrollNews() async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=in&language=en&apiKey=$apikey';
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
          scrollNews.add(article);
        }
      });
    }
    print("this is scroll news$scrollNews");
  }
}
