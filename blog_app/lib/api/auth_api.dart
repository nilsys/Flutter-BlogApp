import 'package:blog_app/models/blog_user.dart';
import 'package:blog_app/notifier/auth_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:blog_app/util/constants.dart' as Constants;
import 'package:tuple/tuple.dart';

Future<bool> signInWithGoogle() async {
  try {
    print("Starting Sigin With google");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    return true;
  } catch (err) {
    print("Error With google signin : $err");
    return false;
  }
}

updatedLogedUserDetails() async {
  User user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  var doc =
      FirebaseFirestore.instance.collection(Constants.users).doc(user.uid);
  DocumentSnapshot snap = await doc.get();
  if (snap.exists) {
    return true;
  } else {
    BlogUser bUser = BlogUser(uid: user.uid, email: user.uid);
    bUser.name = user.displayName;
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      var map = bUser.toMap();

      map.addAll({Constants.timestamp: FieldValue.serverTimestamp()});

      transaction.set(doc, map);
    });
  }
}

Future<void> initializeAuthNotifier(AuthNotifier authNotifier) async {
  User user = FirebaseAuth.instance.currentUser;
  print("***********************************");
  print("$user");
  try {
    var doc =
        FirebaseFirestore.instance.collection(Constants.users).doc(user.uid);
    DocumentSnapshot snap = await doc.get();
    BlogUser bUser = BlogUser.fromMap(snap.data());
    
    authNotifier.setUser(user);
    authNotifier.blogUserDetails(bUser);
  } catch (err) {
    print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ : $err");
    return null;
  }
}

Future<Tuple2<bool, String>> regsiterWithEmailandPassword(
    String email, String password, String name) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    User user = FirebaseAuth.instance.currentUser;
    await user.updateProfile(displayName: name);
    await updatedLogedUserDetails() ; 

    return Tuple2(true, "Registration Successful!");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      return Tuple2(false, "Weak Pasword!");
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      return Tuple2(false, "Account already exits!!");
    }
    return Tuple2(false, "Firebase Authentication Exception!!");
  } catch (e) {
    print(e);
    return Tuple2(false, "An Error occured");
  }
}

//Login using usernam and password

Future<bool> signEmailPassword(String email, String password) async {
  try {
    // Reauthenticate
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    if (FirebaseAuth.instance.currentUser != null)
      return true;
    else
      return false;
  } on FirebaseAuthException catch (err) {
    print("Firebae Authentication Error : $err");
    return false;
  } catch (err) {
    print("Firebae Authentication Error : $err");

    return false;
  }
}
