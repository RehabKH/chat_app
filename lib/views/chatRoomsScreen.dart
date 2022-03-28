import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/socialMediaAuth.dart';
import 'package:chat_app/views/conversitionScreen.dart';
import 'package:chat_app/views/searchScreen.dart';

import 'package:chat_app/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomsScreen extends StatefulWidget {
  const ChatRoomsScreen({Key? key}) : super(key: key);

  @override
  _ChatRoomsScreenState createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  AuthMethods auth = new AuthMethods();
  DataBaseMethods databaseMethods = new DataBaseMethods();
  Stream? chatRoomsStream;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {

    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    databaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomsStream = val;
      });
    });

    HelperFunctions.getUserName().then((value) {
      setState(() {
        Constants.myName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 50,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              final user = FirebaseAuth.instance.currentUser;
              if(user != null){if (user.displayName != null) {
                print("user not null"+user.displayName.toString());
                final provider =
                    Provider.of<SocialMediaAuth>(context, listen: false);
                provider.signOut();
              }} else {
                print("sign out from email auth");   
                auth.signOut();
              
              
              }
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => new Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => new SearchScreen()));
          }),
    );
  }

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: GestureDetector(
                        onTap: () {
                          print("chat room id ::::::::::::::::::" +
                              snapshot.data.docs[index]
                                  .get("chatRoomId")
                                  .toString());
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ConversitionScreen(snapshot
                                  .data.docs[index]
                                  .get("chatRoomId"))));
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 24, horizontal: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.blue, shape: BoxShape.circle),
                              child: Text(
                                snapshot.data.docs[index]
                                    .get("chatRoomId")
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: simpleTextStyle(),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              snapshot.data.docs[index]
                                  .get("chatRoomId")
                                  .toString()
                                  .replaceAll("_", "")
                                  .replaceAll(Constants.myName, ""),
                              style: simpleTextStyle(),
                            )
                          ],
                        ),
                      ),
                    );
                  })
              : Container(
                  child: Center(
                    child: Text(
                      "No data found",
                      style: simpleTextStyle(),
                    ),
                  ),
                );
        });
  }
}
