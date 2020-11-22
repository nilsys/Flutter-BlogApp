import 'package:blog_app/models/blog_user.dart';
import 'package:blog_app/notifier/auth_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:blog_app/util/constants.dart' as Constants;

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
  print("***********************************");

    print("Blog User $bUser");
    authNotifier.setUser(user);
    authNotifier.blogUserDetails(bUser);
  } catch (err) {
    print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ : $err") ;
    return null;
  }
}
