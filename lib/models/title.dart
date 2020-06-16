import "package:flutter/material.dart";

class Titles extends StatelessWidget {
  final Color newsColor;
  Titles({this.newsColor});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "OP ",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: newsColor, fontSize: 23),
        ),
        Text(
          "NEWS",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[500],
              fontSize: 23),
        ),
      ],
    );
  }
}
