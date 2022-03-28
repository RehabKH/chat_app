import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/socialMediaAuth.dart';
import 'package:chat_app/views/chatRoomsScreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    getLoggedIn();
    super.initState();
  }

  getLoggedIn() async {
    await HelperFunctions.getUserLoggedIn().then((value) {
      setState(() {
        isLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SocialMediaAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xff1F1F1F),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.blue,
        ),
        // home: isLoggedIn != null ? isLoggedIn?
        // ChatRoomsScreen() : Authenticate():BlankPage()
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : (snapshot.hasData)
                      ? ChatRoomsScreen()
                      : (snapshot.hasError)
                          ? Center(
                              child: Text(snapshot.error.toString()),
                            )
                          // : isLoggedIn
                          : isLoggedIn
                              ? ChatRoomsScreen()
                              : Authenticate();
              // : BlankPage();
            }),
      ),
    );
  }
}

class BlankPage extends StatelessWidget {
  const BlankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Center(
            child: Text(
              "I am Blank Page",
              style: simpleTextStyle(),
            ),
          ),
        ),
      ),
    );
  }
}
