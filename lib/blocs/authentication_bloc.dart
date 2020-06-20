import 'dart:async';

import 'package:journal/services/authentication_api.dart';

/// Provides stream
///
/// Stream user - Returns uid if user logged in else returns null
///
/// Sink logoutUser - If set true, user is logged out
class AuthenticationBloc {
  final AuthenticationApi authenticationApi;

  AuthenticationBloc(
    this.authenticationApi,
  ) {
    _onAuthChanged();
  }

  StreamController<String> _authenticationController =
      StreamController<String>();
  Sink<String> get _addUser => _authenticationController.sink;

  /// Returns the uid of logged in user else returns null.
  Stream<String> get user => _authenticationController.stream;

  StreamController<bool> _logoutController = StreamController<bool>();

  /// If set true, the user is logged out.
  Sink<bool> get logoutUser => _logoutController.sink;

  void _onAuthChanged() async {
    await authenticationApi.getFirebaseAuth().onAuthStateChanged.listen((user) {
      final String _uid = (user != null) ? user.uid : null;
      _addUser.add(_uid);
      print('User Added : $_uid');
    });
    _logoutController.stream.listen((logout) {
      if (logout) {
        _signOut();
      }
    });
  }

  void dispose() {
    _authenticationController.close();
    _logoutController.close();
  }

  void _signOut() async {
    await authenticationApi.signOut();
  }
}
