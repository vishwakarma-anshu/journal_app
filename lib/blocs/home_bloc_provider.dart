import 'package:flutter/widgets.dart';
import 'package:journal/blocs/home_bloc.dart';

class HomeBlocProvider extends InheritedWidget {
  final HomeBloc homeBloc;
  final String uid;

  HomeBlocProvider({
    Key key,
    @required Widget child,
    @required this.homeBloc,
    @required this.uid,
  })  : assert(homeBloc != null),
        assert(child != null),
        assert(uid != null),
        super(key: key, child: child);

  static HomeBlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeBlocProvider>();
  }

  @override
  bool updateShouldNotify(HomeBlocProvider oldWidget) =>
      homeBloc != oldWidget.homeBloc || uid != oldWidget.uid;
}
