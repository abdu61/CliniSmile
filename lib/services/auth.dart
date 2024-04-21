import 'package:dental_clinic/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object based on firebase user
  Users _userFromFirebaseUser(User firebaseUser) {
    return Users(uid: firebaseUser.uid);
  }

  //Auth Change user stream
  Stream<Users?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => user != null ? _userFromFirebaseUser(user) : null);
  }

  // sign in anonymously
  Future<String?> signInAnon() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;
      if (user != null) {
        return _userFromFirebaseUser(user).uid;
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      // Handle errors (optional)
      print(e.code);
      print(e.message);
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      // Handle errors (optional)
      print(e.code);
      print(e.message);
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      // Handle errors (optional)
      print(e.code);
      print(e.message);
      return null;
    }
  }

  //sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
