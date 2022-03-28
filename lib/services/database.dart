import 'package:cloud_firestore/cloud_firestore.dart';


class DataBaseMethods {
  uploadUserInfo(Map<String, String> userInfo) {
    FirebaseFirestore.instance
        .collection("users")
        .add(userInfo)
        .catchError((e) {
      print("error in save user name and email ::::::::::::::" + e.toString());
    });
  }

  Future getDataByUserName(String userName) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: userName)
        .get();
  }

  Future getDataByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversition(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print("error message in save message :::: " + e.toString());
    });
  }

  getConversition(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
