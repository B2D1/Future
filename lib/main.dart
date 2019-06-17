import 'package:flutter/material.dart';
import 'home_widget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My Flutter App',
      home: Home(),
    );
  }
}
