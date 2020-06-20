import 'package:flutter/material.dart';
import 'package:journal/blocs/login_bloc.dart';
import 'package:journal/services/authentication_service.dart';
import 'package:journal/services/db_firestore_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String title = 'Login';
  LoginBloc _loginBloc;

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(AuthenticationService(), DbFirestoreService());
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          initialData: 'Login',
          stream: _loginBloc.title,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Text('${snapshot.data} Page');
            } else {
              return Text('Authentication');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              emailTextField(),
              const SizedBox(height: 14.0),
              passwordTextField(),
              SizedBox(height: 14.0),
              loginOrCreateUserButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailTextField() {
    return StreamBuilder(
        stream: _loginBloc.email,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            focusNode: _emailFocusNode,
            decoration: InputDecoration(
              labelText: 'Enter Email',
              errorText: snapshot.error,
            ),
            onChanged: _loginBloc.emailChanged.add,
            onSubmitted: (submitted) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
          );
        });
  }

  Widget passwordTextField() {
    return StreamBuilder(
        stream: _loginBloc.password,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            obscureText: true,
            focusNode: _passwordFocusNode,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Enter Password',
              errorText: snapshot.error,
            ),
            onChanged: _loginBloc.passwordChanged.add,
          );
        });
  }

  Widget loginOrCreateUserButtons() {
    Widget loginButtons() {
      return StreamBuilder(
        initialData: false,
        stream: _loginBloc.isLoginOrCreateUserButtonEnabled,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Log In',
                  style: TextStyle(fontSize: 16.0),
                ),
                color: Colors.lightGreen.shade400,
                disabledColor: Colors.grey,
                onPressed: snapshot.data
                    ? () {
                        _loginBloc.loginOrCreateUserChanged.add('Login');
                      }
                    : null,
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Create User',
                  style: TextStyle(fontSize: 16.0),
                ),
                color: Colors.lightGreen.shade300,
                onPressed: () {
                  _loginBloc.setTitle.add('Create User');
                  _loginBloc.loginOrCreateUserButtonChanged.add('Create User');
                },
              ),
            ],
          );
        },
      );
    }

    Widget createUserButtons() {
      return StreamBuilder(
        initialData: false,
        stream: _loginBloc.isLoginOrCreateUserButtonEnabled,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Create User',
                  style: TextStyle(fontSize: 16.0),
                ),
                color: Colors.lightGreen.shade400,
                disabledColor: Colors.grey,
                onPressed: snapshot.data
                    ? () {
                        _loginBloc.loginOrCreateUserChanged.add('Create User');
                      }
                    : null,
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 16.0),
                ),
                color: Colors.lightGreen.shade300,
                onPressed: () {
                  _loginBloc.setTitle.add('Login');
                  _loginBloc.loginOrCreateUserButtonChanged.add('Login');
                },
              ),
            ],
          );
        },
      );
    }

    return StreamBuilder(
      initialData: 'Login',
      stream: _loginBloc.loginOrCreateUserButton,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == 'Login') {
          title = 'Login';
          return loginButtons();
        } else {
          title = 'Create User';
          return createUserButtons();
        }
      },
    );
  }
}
