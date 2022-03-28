import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

// import 'package:intl/date_time_patterns.dart';
// ignore: must_be_immutable
class ConversitionScreen extends StatefulWidget {
  String chatRoomId;
  // Map<String, dynamic> conversitionList;
  ConversitionScreen(this.chatRoomId);

  @override
  _ConversitionScreenState createState() => _ConversitionScreenState();
}

class _ConversitionScreenState extends State<ConversitionScreen> {
  TextEditingController _message = new TextEditingController();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  Stream? chatMessageStream;
  @override
  void initState() {
    dataBaseMethods.getConversition(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              color: Color(0x36FFFFFF),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _message,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Message",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)]),
                          borderRadius: BorderRadius.circular(40)),
                      child: Image.asset("assets/images/send.png"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendMessage() {
    if (_message.text != "") {
      Map<String, dynamic> messageMap = {
        "message": _message.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      dataBaseMethods.addConversition(widget.chatRoomId, messageMap);
      setState(() {
        _message.text = "";
      });
    }
  }

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, AsyncSnapshot snapshot) {
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                    snapshot.data.docs[index]!.get("message").toString(),
                    (snapshot.data.docs[index]!.get("sendBy") == Constants.myName));
              });
        });
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right: 8.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
               alignment: (isSendByMe) ? Alignment.centerRight : Alignment.centerLeft, 
        width: MediaQuery.of(context).size.width,
        child: Container(
        padding: EdgeInsets.symmetric(vertical: 16,horizontal: 24),
          // height: 50,width:150,
            decoration:(isSendByMe)? BoxDecoration(
                color:   Colors.blue[900],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(23),
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                )):
                BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(23),
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
              )),
            child: Text(
              message,
              style: simpleTextStyle(),
            ),
          ),
      ),
    )
        ;
  }
}
