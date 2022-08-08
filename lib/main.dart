import 'package:flutter/material.dart';

import 'package:socialsign/pages/login.dart';

const bgColor = Colors.blue;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SocialSign',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: bgColor,
        brightness: Brightness.dark,
      ),
      home: Login(),
    );
  }
}
