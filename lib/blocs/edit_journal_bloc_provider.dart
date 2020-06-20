import 'package:flutter/widgets.dart';
import 'package:journal/blocs/edit_journal_bloc.dart';

class EditJournalBlocProvider extends InheritedWidget {
  final EditJournalBloc editJournalBloc;

  EditJournalBlocProvider({
    Key key,
    @required Widget child,
    @required this.editJournalBloc,
  }) : super(key: key, child: child);

  static EditJournalBlocProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<EditJournalBlocProvider>();
  }

  @override
  bool updateShouldNotify(EditJournalBlocProvider oldWidget) =>
      editJournalBloc != oldWidget.editJournalBloc;
}
