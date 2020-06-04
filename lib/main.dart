import 'package:flutter/material.dart';
import 'package:leopardmachine/screen/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      title: 'Leopard Machine',
      home: Home(),
    );
  }
}
