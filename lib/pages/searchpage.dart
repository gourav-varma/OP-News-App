import 'package:flutter/material.dart';
import 'package:newstoday_app/models/article.dart';
import 'package:newstoday_app/models/title.dart';
import 'package:newstoday_app/fetchers/searchnews.dart';
import 'package:newstoday_app/pages/webviewpage.dart';
import 'package:provider/provider.dart';

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  List<Article> articles = List<Article>();
  TextEditingController searchController = TextEditingController();
  bool _loading = true;

  fetchSearchArticles() async {
    SearchNews allNews = SearchNews();
    try {
      await allNews.searchNews(searchController.text);
      articles = allNews.news;
    } catch (e) {
      print(e);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 40, left: 25, bottom: 15),
              child: Titles(
                newsColor: Colors.black38,
              )),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  onSubmitted: (value) {
                    if (searchController.text.isNotEmpty) {
                      setState(() {
                        searchController.text;
                        fetchSearchArticles();
                        Provider.of<SearchNews>(context, listen: false)
                            .searchNews(searchController.text);
                      });
                    }
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: "Search...",
                      hintStyle:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ),
            ],
          ),
          Consumer<SearchNews>(
            builder: (context, search, child) => Container(
                child: _loading
                    ? NoSearch()
                    : articles.length != 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              return SearchTile(
                                imageUrl: articles[index].urlToImage,
                                title: articles[index].title,
                                url: articles[index].url,
                                publishedAt: articles[index].publishedAt,
                                source: articles[index].source,
                              );
                            })
                        : NoResults()),
          ),
        ],
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String imageUrl, title, publishedAt, source, url;
  SearchTile(
      {this.imageUrl, this.title, this.publishedAt, this.source, this.url});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleWebView(
                      webUrl: url,
                    )));
      },
      child: Container(
        height: 100,

        ///TODO: adjust height
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[400],
                  blurRadius: 30,
                  offset: Offset(0, 10))
            ]),
        child: Row(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        topLeft: Radius.circular(15)),
                    child: Image.network(
                      imageUrl,
                      height: 100,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return Text('lol');
                      },

                      ///TODO: adjust height
                      width: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    width: width / 1.6,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          width: width / 1.5,
                        ),

                        ///TODO: source and publishedAt
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: <Widget>[
                        //     Text(
                        //       "Sources: $source",
                        //       style: TextStyle(
                        //           fontSize: 10,
                        //           fontWeight: FontWeight.w500,
                        //           color: Colors.grey),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(30),
      height: height / 2,
      width: width,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Find By Keywords",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
          ),
          Container(
              width: width,
              alignment: Alignment.centerLeft,
              child: Text(
                "Looking for a specific headline?",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500]),
              )),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
          ),
          Row(
            children: <Widget>[
              Text(
                "Suggestion:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
          ),
          Row(
            children: <Widget>[
              SuggestionTile(
                text: "Narendra Modi",
                widths: 180,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
              ),
              SuggestionTile(
                text: "Movies",
                widths: 100,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
          ),
          Row(
            children: <Widget>[
              SuggestionTile(
                text: "Cricket",
                widths: 100,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
              ),
              SuggestionTile(
                text: "Elon Musk",
                widths: 130,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
              ),
              SuggestionTile(
                text: "Apple",
                widths: 100,
              )
            ],
          )
        ],
      ),
    );
  }
}

class SuggestionTile extends StatelessWidget {
  final String text;
  final double widths;
  SuggestionTile({this.text, this.widths});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: widths,
      height: 30,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white70),
      ),
      decoration: BoxDecoration(
          color: Colors.teal, borderRadius: BorderRadius.circular(10)),
    );
  }
}

class NoResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height / 1.5,
      width: width / 1.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: height / 3,
            alignment: Alignment.bottomCenter,
            child: Text(
              "NO RELATED NEWS FOUND",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          Container(
            height: height / 4,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "You outsmart our app :(",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  "Please try to be more specific.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
