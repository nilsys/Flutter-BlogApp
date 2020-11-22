import 'package:blog_app/api/auth_api.dart';
import 'package:blog_app/models/blog_user.dart';
import 'package:blog_app/notifier/auth_notifier.dart';
import 'package:blog_app/pages/homepage.dart';
import 'package:blog_app/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:blog_app/util/constants.dart' as Constants;
import 'package:provider/provider.dart';

///
/// Widget for displaying loading animation and doing background work at the same time.
///
class EzTransition extends StatefulWidget {
  EzTransition(this.child, {this.backgroundColor});

  // final Function() toProcess;
  final Widget child;
  final Color backgroundColor;

  @override
  _EzTransitionState createState() => _EzTransitionState();
}

class _EzTransitionState extends State<EzTransition> {
  @override
  void initState() {
    super.initState();
    toProcess();
  }

  AuthNotifier authNotifier;

  void toProcess() async {
    await getData();
    // Firebase.initializeApp();
    // var user = FirebaseAuth.instance.currentUser;
    // bool result = user == null ? false : true;

    await Future.delayed(const Duration(seconds: 3));

    print("Auth User : ${authNotifier.user}");
    if (authNotifier.user == null) {
      print("Pushing Login!!");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ));
      print("Pushed login!!");
    } else {
      print("Pushing Home!!");
      Navigator.of(context).pushReplacementNamed('/navigationbar');

      print("Pushed home!!"); 
    }
  }

  @override
  Widget build(BuildContext context) {
    authNotifier = Provider.of<AuthNotifier>(context);

    return Material(
        color: getBackgroundColor(),
        child: Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.cyan,
          strokeWidth: 5,
        )));
  }

  Color getBackgroundColor() {
    return widget.backgroundColor == null
        ? Theme.of(context).backgroundColor
        : widget.backgroundColor;
  }

  Future<void> getData() async {
    await Firebase.initializeApp();
    User user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    initializeAuthNotifier(authNotifier);
  }
}
