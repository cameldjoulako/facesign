import 'package:flutter/material.dart';
import 'package:socialsign/services/authentification.dart';
import 'package:socialsign/widgets/facebook_button.dart';

const Color bgColor = Color.fromARGB(255, 7, 91, 226);

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/firebase_logo.png',
                        height: 160,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Social Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                      ),
                    ),
                    Text(
                      "Connexion Facebook",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: Authentication.initApp(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Erreur d'initialisation de Firebase ");
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return const FacebookButton();
                  }
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
