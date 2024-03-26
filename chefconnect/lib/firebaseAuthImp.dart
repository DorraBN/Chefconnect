import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print("Email is already in use.");
      } else {
        print("An error occurred: $e");
      }
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        print("Invalid email or password.");
      } else {
        print("An error occurred: $e");
      }
      return null;
    }
  }

  Future<String?> getUsername(String userEmail) async {
  try {
    QuerySnapshot querySnapshot = await _firestore
        .collection('registration')
        .where('email', isEqualTo: userEmail)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      // Utilisez le premier document correspondant s'il y en a plusieurs (ce qui ne devrait pas arriver)
      return querySnapshot.docs.first.get('username');
    } else {
      print('User not found in the registration collection.');
      return null;
    }
  } catch (e) {
    print("An error occurred: $e");
    return null;
  }
}
}