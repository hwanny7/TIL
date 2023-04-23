import 'package:flutter/material.dart';

class Market extends StatefulWidget {
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBar(
                title: TextField(
              decoration: InputDecoration(hintText: 'Search... '),
            ))),
        body: Text('Market', style: TextStyle(fontSize: 40)));
  }
}
