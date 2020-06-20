import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal/services/authentication_api.dart';

class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  @override
  Future<String> signInWithEmailAndPassword({
    String email,
    String password,
  }) async {
    String _uid;
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((result) {
      _uid = result.user.uid;
    }).catchError((error) {
      print('Error Signing In : $error');
      _uid = null;
    });
    return _uid;
  }

  @override
  Future<String> createUserWithEmailAndPassword(
      {String email, String password}) async {
    String _uid;
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) {
      if (result != null) {
        _uid = result.user.uid;
      }
    }).catchError((error) {
      print('Error Occured : $error');
    });

    return _uid;
  }

  @override
  Future<String> getCurrentUserUid() async {
    String _uid;
    await _firebaseAuth.currentUser().then((user) => _uid = user.uid);
    return _uid;
  }

  @override
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
