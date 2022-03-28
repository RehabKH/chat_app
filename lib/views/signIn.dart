import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/socialMediaAuth.dart';
import 'package:chat_app/views/chatRoomsScreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final Function toggleAuth;
  SignIn(this.toggleAuth);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final key = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController email = new TextEditingController(),
      pass = new TextEditingController();
  QuerySnapshot? snapshotUserInfo;
  DataBaseMethods databaseMethods = new DataBaseMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: (_isLoading)
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
                        controller: email,
                        style: simpleTextStyle(),
                        decoration: inputDecoration("email"),
                      ),
                      TextFormField(
                        controller: pass,
                        obscureText: true,
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
                          setState(() {
                            _isLoading = true;
                          });
                          databaseMethods
                              .getDataByUserEmail(email.text)
                              .then((value) {
                            snapshotUserInfo = value;
                            HelperFunctions.saveUserName(
                                snapshotUserInfo!.docs[0].get("name"));
                          });

                          authMethods
                              .signInWithEmailAndPass(email.text, pass.text)
                              .then((value) {
                            HelperFunctions.saveUserEmail(email.text);
                            HelperFunctions.saveUserLoggedIn(true);
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new ChatRoomsScreen()));
                          });
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
                            "Sign In",
                            style: simpleTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          final provider = Provider.of<SocialMediaAuth>(context,
                              listen: false);
                          provider.googleLogin().then((value) {
                          final user = FirebaseAuth.instance.currentUser;

                            HelperFunctions.saveUserName(
                              user!.displayName.toString());
                            setState(() {
                              _isLoading = true;
                            });
                            HelperFunctions.saveUserEmail(user.email.toString());
                            HelperFunctions.saveUserLoggedIn(true);
                            setState(() {
                              _isLoading = false;
                            });
                          });

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => new ChatRoomsScreen()));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.white),
                          child: Text(
                            "Sign In With Google",
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
                            "Don't have account,",
                            style: simpleTextStyle(),
                          ),
                          InkWell(
                            onTap: () {
                              widget.toggleAuth();
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => new Authenticate()));
                            },
                            child: Text(
                              "Register Now?",
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
  signIn() {
    if (key.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      authMethods.signInWithEmailAndPass(email.text, pass.text).then((value) {
        setState(() {
          _isLoading = false;
          email.text = "";
          pass.text = "";
        });
        print("valuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuue " + value.toString());
      });
    }
  }
}
