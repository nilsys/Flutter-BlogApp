import 'package:blog_app/models/blog_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService() {
    Firebase.initializeApp(); 
  }

  // auth change user stream
  Stream<BlogUser> get user {
    return _auth.authStateChanges().map((user) =>
        user != null ? BlogUser(uid: user.uid, email: user.email) : null);
  }


  // sign in with email and password

  // register with email and password

  // sign out

}
