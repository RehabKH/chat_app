import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chat_app/services/socialMediaAuth.dart';
import 'package:chat_app/views/chatRoomsScreen.dart';

import 'package:chat_app/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final Function toggleAuth;
  SignUp(this.toggleAuth);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;

  final key = GlobalKey<FormState>();
  TextEditingController userName = new TextEditingController(),
      email = new TextEditingController(),
      password = new TextEditingController();
  DataBaseMethods _dataBaseMethods = new DataBaseMethods();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height - 150,
                child: Form(
                  key: key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        validator: validate,
                        controller: userName,
                        style: simpleTextStyle(),
                        decoration: inputDecoration("User Name"),
                      ),
                      TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "please provide valid email format";
                        },
                        controller: email,
                        style: simpleTextStyle(),
                        decoration: inputDecoration("email"),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: validate,
                        controller: password,
                        style: simpleTextStyle(),
                        decoration: inputDecoration("Password"),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            "Forget Password?",
                            style: simpleTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () {
                          signUp(false);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              gradient: LinearGradient(colors: [
                                Color(0xff007EF4),
                                Color(0xff2A75BC)
                              ])),
                          child: Text(
                            "Sign Up",
                            style: simpleTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          signUp(true);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.white),
                          child: Text(
                            "Sign Up With Google",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have account,",
                            style: simpleTextStyle(),
                          ),
                          InkWell(
                            onTap: () {
                              widget.toggleAuth();
                            },
                            child: Text(
                              "Sign In Now?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  AuthMethods authMethods = new AuthMethods();
  signUp(bool socialSignIn) {
    setState(() {
      _isLoading = true;
    });
    if (!socialSignIn) {
      if (key.currentState!.validate()) {
        authMethods
            .signUpWithEmailAndPass(email.text, password.text)
            .then((value) {
          Map<String, String> userInfo = {
            "name": userName.text,
            "email": email.text
          };
          // }

          HelperFunctions.saveUserEmail(email.text);
          HelperFunctions.saveUserName(userName.text);

          _dataBaseMethods.uploadUserInfo(userInfo);
          HelperFunctions.saveUserLoggedIn(true);
          setState(() {
            _isLoading = false;

            userName.text = "";
            email.text = "";
            password.text = "";
          });
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => new ChatRoomsScreen()));
        });
      }
    } else {
      final provider = Provider.of<SocialMediaAuth>(context, listen: false);
      provider.googleLogin().then((value) {
        
        final _user = FirebaseAuth.instance.currentUser;
        Map<String, String> userInfo = {
          "name": _user!.displayName.toString(),
          "email": _user.email.toString()
        };

        Fluttertoast.showToast(
            msg: "current user name:  " + _user.displayName.toString());
        HelperFunctions.saveUserEmail(_user.email.toString());
        HelperFunctions.saveUserName(_user.displayName.toString());

        _dataBaseMethods.uploadUserInfo(userInfo);
        HelperFunctions.saveUserLoggedIn(true);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => new ChatRoomsScreen()));
      });
    }
  }
}
