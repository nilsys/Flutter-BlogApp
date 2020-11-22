import 'package:blog_app/pages/editprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/pages/signup.dart';
import 'package:blog_app/pages/login.dart';
import 'package:blog_app/pages/firstpage.dart';
import 'package:blog_app/pages/navigationbar.dart';
import 'package:blog_app/pages/profilepage.dart';
import 'package:blog_app/pages/editprofile.dart';
import 'package:blog_app/pages/newpost.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/navigationbar',
    routes: {
      '/login': (context) => Login(),
      '/signup': (context) => SignUp(),
      '/firstpage': (context) => FirstPage(),
      '/navigationbar': (context) => NavigationBar(),
      '/profilepage': (context) => ProfilePage(),
      '/editprofile': (context) => EditProfile(),
      '/newpost': (context) => NewPost(),
    },
  ));
}



