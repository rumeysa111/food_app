import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  //get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }


  // Kullanıcı oturum açmış mı?
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
  //sign in
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      //sign user in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      //save user info if it doenst already exist
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
          {
            'uid':userCredential.user!.uid,'email':email
          }
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


//sign up
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      //create user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      //save user info in a seperate doc
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid':userCredential.user!.uid,'email':email
        }
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception((e.code));
    }
  }

//sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
class GoogleSignInProvider
{

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

// Google ile giriş yapma
Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase oturum açma
      UserCredential userCredential = await _auth.signInWithCredential(
          credential);

      // Firestore'da kullanıcı mevcut değilse ekle
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _firestore.collection("Users").doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'displayName': userCredential.user!.displayName,
          'photoURL': userCredential.user!.photoURL,
        });
      }

      return userCredential.user;
    }
  } catch (e) {
    print("Google oturum açma hatası: $e");
  }
  return null;
}

// Google ile oturumu kapatma
Future<void> signOut() async {
  await _googleSignIn.signOut();
  await _auth.signOut();
}}