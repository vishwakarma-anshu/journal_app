import 'dart:async';

import 'package:journal/classes/validators.dart';
import 'package:journal/services/authentication_api.dart';
import 'package:journal/services/database_api.dart';

class LoginBloc with Validators {
  final AuthenticationApi authenticationApi;
  final DbApi dbApi;

  String _email;
  String _password;
  bool _validateEmail = false;
  bool _validatePassword = false;

  LoginBloc(this.authenticationApi, this.dbApi) {
    _setListerners();
  }

  StreamController<String> _emailController =
      StreamController<String>.broadcast();
  Sink<String> get emailChanged => _emailController.sink;
  Stream<String> get email => _emailController.stream.transform(validateEmail);

  StreamController<String> _passwordController =
      StreamController<String>.broadcast();
  Sink<String> get passwordChanged => _passwordController.sink;
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  StreamController<bool> _enableLoginOrCreateUserButtonController =
      StreamController<bool>();
  Sink<bool> get _enableLoginOrCreateUserButton =>
      _enableLoginOrCreateUserButtonController.sink;
  Stream<bool> get isLoginOrCreateUserButtonEnabled =>
      _enableLoginOrCreateUserButtonController.stream;

  StreamController<String> _loginOrCreateUserButtonController =
      StreamController<String>();
  Sink<String> get loginOrCreateUserButtonChanged =>
      _loginOrCreateUserButtonController.sink;
  Stream<String> get loginOrCreateUserButton =>
      _loginOrCreateUserButtonController.stream;

  StreamController<String> _loginOrCreateUserController =
      StreamController<String>.broadcast();
  Sink<String> get loginOrCreateUserChanged =>
      _loginOrCreateUserController.sink;
  Stream<String> get loginOrCreateUser => _loginOrCreateUserController.stream;

  StreamController<String> _titleController = StreamController<String>();
  Sink<String> get setTitle => _titleController.sink;
  Stream<String> get title => _titleController.stream;

  void _setListerners() {
    email.listen((email) {
      _email = email;
      _validateEmail = true;
      _updateLoginOrCreateUserButton();
    }).onError((error) {
      _email = '';
      _validateEmail = false;
      _updateLoginOrCreateUserButton();
    });

    password.listen((password) {
      _password = password;
      _validatePassword = true;
      _updateLoginOrCreateUserButton();
    }).onError((error) {
      _password = '';
      _validatePassword = false;
      _updateLoginOrCreateUserButton();
    });

    loginOrCreateUser.listen((event) {
      if (event == 'Login') {
        _loginUser();
      } else if (event == 'Create User') {
        _createUser();
      }
    });
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _titleController.close();
    _enableLoginOrCreateUserButtonController.close();
    _loginOrCreateUserButtonController.close();
    _loginOrCreateUserController.close();
  }

  void _updateLoginOrCreateUserButton() {
    if (_validateEmail && _validatePassword) {
      _enableLoginOrCreateUserButton.add(true);
    } else {
      _enableLoginOrCreateUserButton.add(false);
    }
  }

  void _createUser() {
    if (_validateEmail && _validatePassword) {
      authenticationApi
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((user) async {
        bool _userAdded = await dbApi.addNewUser(user, _email, _password);
        if (_userAdded) {
          print('User Added to DB');
        } else {
          print('Could not added the user to DB');
        }
        print('User Created : $user');
      }).catchError((error) {
        print('Error Creating User: $error');
      });
    }
  }

  void _loginUser() {
    if (_validateEmail && _validatePassword) {
      authenticationApi
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        print('Home Bloc : User Signed In');
      }).catchError((error) {
        print('Error Signing In User: $error ');
      });
    }
  }
}
