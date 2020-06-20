abstract class AuthenticationApi {
  /// Returns the Firebase Instance.
  getFirebaseAuth();

  /// Returns the uid of logged in user.
  Future<String> getCurrentUserUid();

  /// Returns the uid of the user on successfull signin else returns null
  Future<String> signInWithEmailAndPassword({String email, String password});

  /// Returns the uid of the user on successfull signin else returns null
  Future<String> createUserWithEmailAndPassword(
      {String email, String password});

  /// Signs the user out.
  Future<void> signOut();
}
