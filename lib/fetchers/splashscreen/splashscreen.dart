import 'dart:async';
import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // StreamSubscription<DataConnectionChecker> listener;
  // bool loading = true;
  checkInternet() async {
    print("The statement 'this machine is connected to the Internet' is: ");

    print(await DataConnectionChecker().hasConnection);

    print("Current status: ${await DataConnectionChecker().connectionStatus}");

    print("Last results: ${DataConnectionChecker().lastTryResults}");

    var listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    });

    // close listener after 30 seconds, so the program doesn't run forever
    await Future.delayed(Duration(seconds: 5));
    await listener.cancel();

    return DataConnectionChecker().connectionStatus;
  }

  finalCheck() async {
    DataConnectionStatus status = await checkInternet();
    if (status == DataConnectionStatus.connected) {
      print(" you are connected");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("No Internet Detected"),
                content: Text(
                    "Please check your internet connection and try again."),
              ));
      print("your not connected");
    }
  }

  @override
  void initState() {
    finalCheck();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // gradient: RadialGradient(
          //   colors: [Colors.yellow,Colors.orange,Colors.deepOrangeAccent],
          //   radius: 0.9
          // ),
          color: Colors.white
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height/2,
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("OP ",style: TextStyle(
                        color: Colors.black,fontSize: 40,fontWeight: FontWeight.w500
                      ),),
                      Text("NEWS",style: TextStyle(
                        color: Colors.blue,fontSize: 40,fontWeight: FontWeight.w500
                      ),)
                      ],
                  )),
                  Container(
                    height: MediaQuery.of(context).size.height/2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                      ],
                    ),
                  )
            ]),
      ),
    );
  }
}
