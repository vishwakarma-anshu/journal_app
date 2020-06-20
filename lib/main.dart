import 'package:flutter/material.dart';
import 'package:journal/blocs/authenticaiton_bloc_provider.dart';
import 'package:journal/blocs/authentication_bloc.dart';
import 'package:journal/blocs/home_bloc.dart';
import 'package:journal/blocs/home_bloc_provider.dart';
import 'package:journal/pages/home_page.dart';
import 'package:journal/pages/login_page.dart';
import 'package:journal/services/authentication_service.dart';
import 'package:journal/services/db_firestore_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(AuthenticationService());
    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc,
      child: StreamBuilder(
        initialData: null,
        stream: _authenticationBloc.user,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return HomeBlocProvider(
              homeBloc: HomeBloc(AuthenticationService(), DbFirestoreService()),
              uid: snapshot.data,
              child: _buildMaterialApp(HomePage()),
            );
          } else {
            return _buildMaterialApp(LoginPage());
          }
        },
      ),
    );
  }

  MaterialApp _buildMaterialApp(Widget page) {
    return MaterialApp(
      title: 'Journal App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        scaffoldBackgroundColor: Colors.lightGreen.shade200,
      ),
      home: page,
    );
  }
}
