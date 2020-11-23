import 'package:blog_app/notifier/auth_notifier.dart';
import 'package:blog_app/pages/editprofile.dart';
import 'package:blog_app/pages/homepage.dart';
import 'package:blog_app/pages/splash.dart';
import 'package:blog_app/service/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/pages/signup.dart';
import 'package:blog_app/pages/login.dart';
import 'package:blog_app/pages/firstpage.dart';
import 'package:blog_app/pages/navigationbar.dart';
import 'package:blog_app/pages/profilepage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthNotifier(),
      )
    ],
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/navigationbar',
      initialRoute: "/splash",
      // home: HomePage(),

      routes: {
        '/splash': (context) =>
            EzTransition(Text("Hello"), backgroundColor: Colors.white),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/homePage': (context) => HomePage(),
        '/firstpage': (context) => FirstPage(),
        '/navigationbar': (context) => NavigationBar(),
        '/profilepage': (context) => ProfilePage(),
        '/editprofile': (context) => EditProfile() 
      },
    );
  }
}
