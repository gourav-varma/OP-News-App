import 'package:flutter/material.dart';
import 'package:newstoday_app/fetchers/categorynews.dart';
import 'package:newstoday_app/models/article.dart';
import 'package:newstoday_app/models/title.dart';
import 'package:newstoday_app/pages/webviewpage.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin<CategoryPage> {
  List<Article> articles = List<Article>();
  bool _loading = true;
  String category = "general";
  String categoryName = "NATIONAL";

  @override
  bool get wantKeepAlive => true;

  fetchArticles(category) async {
    CategoryNews allNews = CategoryNews();
    await allNews.getNews(category);
    articles = allNews.news;
    if (mounted) {
    setState(() {
      _loading = false;
    });
    }
  }

  @override
  void initState() {
    fetchArticles(category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("this is the current category: $category");
    return Container(
      // margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 40, left: 25, bottom: 15),
                child: Titles(
                  newsColor: Colors.black38,
                )),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          categoryName = "NATIONAL";
                          _loading = true;
                        });
                        fetchArticles("general");
                        Provider.of<CategoryNews>(context, listen: false)
                            .getNews("general");
                      },
                      child: CategoryTile(
                        text: "NATIONAL",
                        colors: Colors.red,
                        width: 100,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        fetchArticles("business");
                        setState(() {
                          categoryName = "BUSINESS";
                          _loading = true;
                        });
                        Provider.of<CategoryNews>(context, listen: false)
                            .getNews("business");
                      },
                      child: CategoryTile(
                        text: "BUSINESS",
                        colors: Colors.blue,
                        width: 100,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        fetchArticles("entertainment");
                        setState(() {
                          categoryName = "ENTERTAINMENT";
                          _loading = true;
                        });
                        Provider.of<CategoryNews>(context, listen: false)
                            .getNews("entertainment");
                      },
                      child: CategoryTile(
                        text: "ENTERTAINMENT",
                        colors: Colors.yellow,
                        width: 150,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        fetchArticles("sports");
                        setState(() {
                          categoryName = "SPORTS";
                          _loading = true;
                        });
                        Provider.of<CategoryNews>(context, listen: false)
                            .getNews("sports");
                      },
                      child: CategoryTile(
                        text: "SPORTS",
                        colors: Colors.green,
                        width: 80,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top:20),),
            Container(
              margin: EdgeInsets.only(left:30),
              alignment: Alignment.centerLeft,
              child: Text("$categoryName NEWS",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              )),
              Divider(color: Colors.black,indent: 30,endIndent: 30,),
            Consumer<CategoryNews>(
              builder: (context, value, child) {
                return Container(
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
                              publishedAt: articles[index].publishedAt,
                              source: articles[index].source,
                              category: categoryName,
                            );
                          }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String text;
  final Color colors;
  final double width;
  CategoryTile({this.text, this.colors, this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: 10),
      height: 40,
      width: width,
      decoration: BoxDecoration(
          border: Border.all(color: colors),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
    );
  }
}

class ArticleTile extends StatelessWidget {
  final String imageUrl, title, publishedAt, source, url, category;
  final Color colors;
  ArticleTile(
      {@required this.imageUrl,
      @required this.title,
      @required this.publishedAt,
      @required this.source,
      @required this.url,
      this.category,
      this.colors});
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
        height: 100,///TODO: adjust height
        margin: EdgeInsets.only(bottom: 10,left: 10,right: 10),
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
                    width: width / 1.6,
                    height: 100,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 10,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Text(
                              title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            width: width / 1.5,
                          ),
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
