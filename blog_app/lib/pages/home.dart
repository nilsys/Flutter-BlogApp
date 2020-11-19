import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  FirebaseAuth auth = FirebaseAuth.instance;
  String email;

  _HomePageState() {
    email = auth.currentUser.email;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Home Page!!$email"),
    );
  }
}
