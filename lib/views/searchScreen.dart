import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversitionScreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _search = new TextEditingController();
  QuerySnapshot? searchSnapshot;
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  final user = FirebaseAuth.instance.currentUser;
  searchResult() {
    
    dataBaseMethods.getDataByUserName(_search.text).then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  Widget listViewResult() {
    return ListView.builder(
        itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(searchSnapshot!.docs[index].get("name"),
                style: simpleTextStyle()),
            subtitle: Text(searchSnapshot!.docs[index].get("email"),
                style: simpleTextStyle()),
            trailing: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white))),
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: () {
                  createChatRoomAndStartConversition(context, _search.text);
                },
                child: Padding(
                  padding: EdgeInsets.all(3),
                  child: Text(
                    "Message",
                    style: simpleTextStyle(),
                  ),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              color: Color(0x36FFFFFF),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _search,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Search username",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      searchResult();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)]),
                          borderRadius: BorderRadius.circular(40)),
                      child: Image.asset("assets/images/search_white.png"),
                    ),
                  )
                ],
              ),
            ),
            (searchSnapshot == null)
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height - 150,
                    child: listViewResult(),
                  )
          ],
        ),
      ),
    );
  }

  createChatRoomAndStartConversition(BuildContext context, String userName) {
    String chatRoomId = getChatRoomId(userName, Constants.myName);
    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": chatRoomId
    };
    dataBaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => new ConversitionScreen(chatRoomId)));
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else
      return "$a\_$b";
  }

  String _myName = "";
  getuserName() async {
    _myName = await HelperFunctions.getUserName();
  }
}
