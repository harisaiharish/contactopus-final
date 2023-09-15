import 'package:flutter/material.dart';
import 'package:qrcode/home_page4.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contactopus',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: HomePage4(),
    );
  }
}
