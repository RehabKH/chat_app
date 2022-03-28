import 'package:flutter/material.dart';

AppBar appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset(
      "assets/images/logo.png",
      height: 50,
    ),
  );
}

InputDecoration inputDecoration(String hint) {
  return InputDecoration(
      hintText: hint,
      
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

String? validate(String? val) {
  return (val!.isEmpty) || (val.length < 6)? "Please enter valid value length" : null;
}
