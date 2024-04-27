import 'package:dental_clinic/models/user.dart';
import 'package:dental_clinic/services/database.dart';
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
        // Assign a default role to the guest user with sample data
        await DatabaseService(uid: user.uid).updateUserData(
            'Guest User', 'guest@domain.com', '12345678', 'guest');
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

// Get user role
  Future<String> getUserRole(String uid) async {
    final userData = await DatabaseService(uid: uid).getUserData();
    return userData['role'];
  }

  //register with email and password - patient
  Future registerWithEmailAndPassword(
      String name, String email, String phone, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;

      // Create a new document for the user with the role 'Customer'
      await DatabaseService(uid: user!.uid)
          .updateUserData(name, email, phone, 'Customer');

      return _userFromFirebaseUser(user);
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
      // Get the current user
      User? user = _auth.currentUser;

      // Delete the user data if the user is anonymous
      if (user != null && user.isAnonymous) {
        await DatabaseService(uid: user.uid).deleteUserData();
        await user.delete();
      }

      // Sign out the user
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
