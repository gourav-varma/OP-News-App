import 'package:flutter/material.dart';
import 'package:newstoday_app/fetchers/categorynews.dart';
import 'package:provider/provider.dart';
import 'pages/categorypage.dart';
import 'pages/searchpage.dart';
import 'pages/homepage.dart';
import 'fetchers/categorynews.dart';
import 'fetchers/searchnews.dart';
import 'fetchers/splashscreen/splashscreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsToday',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.grey ///circular progress indicator
        ),
      home: 
      // Home()
      SplashScreen()
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
          ChangeNotifierProvider(create: (context) => CategoryNews()),
          ChangeNotifierProvider(create: (context) => SearchNews())
      ],
          child: DefaultTabController(
        length: 3,
        initialIndex: 0,
            child: Scaffold(
          bottomNavigationBar: Material(
            color: Colors.black,
            child: TabBar(
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black26,
              labelColor: Colors.blue,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.home, size: 30),
                ),
                Tab(
                  icon: Icon(Icons.add_circle, size: 30),
                ),
                Tab(
                  icon: Icon(Icons.search, size: 30),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              HomePage(),
              CategoryPage(),
              CountryPage()
            ],
          )
        ),
      ),
    );
  }
}