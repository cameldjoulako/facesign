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
      home: FutureBuilder(
        future: Authentication.initApp(context: context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Erreur d'initialisation de Firebase");
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Login();
          }
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white,
            ),
          );
        },
      ),
    );
  }
}
