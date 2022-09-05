import 'package:flutter/material.dart';
import 'package:socialsign/pages/login.dart';
import 'package:socialsign/services/authentification.dart';

const bgColor = Colors.blue;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: bgColor,
      ),
      home: Login(),
    );
  }
}
