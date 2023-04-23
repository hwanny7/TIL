import 'package:flutter/material.dart';

class KnowHow extends StatefulWidget {
  @override
  _KnowHowState createState() => _KnowHowState();
}

class _KnowHowState extends State<KnowHow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBar(
                title: TextField(
              decoration: InputDecoration(hintText: 'Search... '),
            ))),
        body: Text('KnowHow', style: TextStyle(fontSize: 40)));
  }
}
