import 'package:flutter/widgets.dart';
import 'package:journal/blocs/authentication_bloc.dart';

class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc;

  AuthenticationBlocProvider({
    Key key,
    @required this.authenticationBloc,
    @required Widget child,
  })  : assert(authenticationBloc != null),
        assert(child != null),
        super(key: key, child: child);

  static AuthenticationBlocProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>();
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider oldWidget) =>
      authenticationBloc != oldWidget.authenticationBloc;
}
