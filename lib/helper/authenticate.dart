import 'package:chat_app/views/signIn.dart';
import 'package:chat_app/views/signUp.dart';

import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleAuth() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (showSignIn) ? SignIn(toggleAuth) : SignUp(toggleAuth);
  }
}
