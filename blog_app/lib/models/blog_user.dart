import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:blog_app/util/constants.dart' as Constants;
import 'package:firebase_auth/firebase_auth.dart';

class BlogUser {
  String uid;
  String email, picUrl, userName, name;
  BlogUser.fromSnapShot(DocumentSnapshot snap) {
    this.uid = snap.get(Constants.uid);
    this.email = snap.get(Constants.email);
    this.picUrl = snap.get(Constants.img);
    this.name = snap.get(Constants.name);
    this.userName = snap.get(Constants.userName);
  }
  BlogUser({this.uid, this.email});

  BlogUser.user(User user) {
    BlogUser(email: user.email, uid: user.uid);
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.uid: uid,
      Constants.email: email,
      Constants.img: picUrl,
      Constants.name: name,
      Constants.userName: userName
    };
  }
}
