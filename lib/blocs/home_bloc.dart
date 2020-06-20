import 'dart:async';

import 'package:journal/models/journal.dart';
import 'package:journal/services/authentication_api.dart';
import 'package:journal/services/database_api.dart';

/// Provides Sink and Stream
///
/// Stream getJournals - Used to fetch the list of journals from database.
///
/// Sink deleteJournal - Used to delete journal from database.
class HomeBloc {
  final AuthenticationApi authenticationApi;
  final DbApi dbApi;

  HomeBloc(this.authenticationApi, this.dbApi) {
    _startListeners();
  }

  StreamController<List<Journal>> _journalsController =
      StreamController<List<Journal>>.broadcast();

  /// Add list of journal to the stream.
  Sink<List<Journal>> get addJournals => _journalsController.sink;

  /// Returns the list of journals from the database.
  Stream<List<Journal>> get getJournals => _journalsController.stream;

  StreamController<Journal> _journalController = StreamController<Journal>();
  Sink<Journal> get addJournal => _journalController.sink;

  StreamController<Journal> _journalDeleteController =
      StreamController<Journal>();

  /// Used to delete journal.
  Sink<Journal> get deleteJournal => _journalDeleteController.sink;

  void _startListeners() {
    authenticationApi.getFirebaseAuth().currentUser().then((user) {
      print('Current User : $user');
      dbApi.getJournals(user.uid).listen((journalDoc) {
        addJournals.add(journalDoc);
      });
    });

    _journalController.stream.listen((journal) async {
      await dbApi.addJournal(journal);
    });

    _journalDeleteController.stream.listen((journal) {
      dbApi.deleteJournal(journal);
    });
  }

  void dispose() {
    _journalsController.close();
    _journalController.close();
    _journalDeleteController.close();
  }
}
