import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int number = 0;
  void onPressed() {
    setState(() {
      number++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text('$number', style: TextStyle(fontSize: 40)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            onPressed();
          },
          child: Icon(Icons.add),
        ));
  }
}
