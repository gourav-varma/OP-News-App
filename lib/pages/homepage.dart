import 'package:flutter/material.dart';
import 'package:newstoday_app/models/article.dart';
import 'package:newstoday_app/fetchers/homenews.dart';
import 'package:newstoday_app/models/title.dart';
import 'package:newstoday_app/pages/webviewpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage>{
  List<Article> articles = List<Article>();
  List<Article> scrollArticles = List<Article>();
  bool _loading = true;

  @override
  bool get wantKeepAlive => true;

  fetchArticles() async {
    News allNews = News();
    ScrollNews allScrollNews = ScrollNews();
    try {
      await allNews.getNews();
      articles = allNews.news;
    } catch (e) {
      print(e);
    }
    try {
      await allScrollNews.getScrollNews();
      scrollArticles = allScrollNews.scrollNews;
    } catch (e) {
      print(e);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    fetchArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return  _loading ? Container(
          alignment: Alignment.center,
          child: Container(child: CircularProgressIndicator()),)
      : SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  height: height / 3,
                  width: width,
                  child: _loading
                      ?  Container()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: PageScrollPhysics(),
                          itemCount: scrollArticles.length,
                          scrollDirection: Axis.horizontal,
                          addAutomaticKeepAlives: true,
                          itemBuilder: (context, index) {
                            return ScrollArticleTile(
                              imageUrl: scrollArticles[index].urlToImage,
                              title: scrollArticles[index].title,
                              url: scrollArticles[index].url,
                              source: scrollArticles[index].source,
                            );
                          })),
              Positioned(
                top: 40,
                left: 25,
                child: Container(
                  child: Titles(
                    newsColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13),
              ),
              Text(
                "Trending News",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
              ),
            ],
          ),
          Divider(
            color: Colors.blue[300],
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
          ),
          Container(
            child: _loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return ArticleTile(
                        imageUrl: articles[index].urlToImage,
                        title: articles[index].title,
                        url: articles[index].url,
                      );
                    }),
          )
        ],
      ),
    );
  }
}

class ArticleTile extends StatelessWidget {
  final String imageUrl, title, url;
  ArticleTile(
      {@required this.imageUrl,
      @required this.title,
      @required this.url});
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
                      width: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    width: width / 1.45,
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

class ScrollArticleTile extends StatelessWidget {
  final String imageUrl, title, source, url;
  ScrollArticleTile(
      {@required this.imageUrl,
      @required this.title,
      @required this.source,
      @required this.url});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
        width: width,
        height: height / 3,
        child: Stack(children: <Widget>[
          Stack(
            children: <Widget>[
              Image.network(
                imageUrl,
                height: height / 3,
                width: width,
                fit: BoxFit.fill,
              ),
              Container(
                color: Colors.black38,
              ),
              Positioned(
                  bottom: 30,
                  right: 20,
                  left: 25,
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          // "Source : " + ///TODO : decide about "source"
                          source,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        "$title",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ))),
              // Positioned(
              //     top: 60,
              //     left: 40,
              //     child: Container(
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           color: Colors.black12,
              //         ),
              //         child: Text(
              //           // "Source : " + ///TODO : decide about "source"
              //           source,
              //           style: TextStyle(
              //             color: Colors.white70,
              //             fontSize: 12,
              //           ),
              //         ))),
            ],
          ),
        ]),
      ),
    );
  }
}
