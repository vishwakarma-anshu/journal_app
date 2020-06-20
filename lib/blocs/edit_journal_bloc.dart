import 'dart:async';

import 'package:journal/models/journal.dart';
import 'package:journal/services/database_api.dart';

class EditJournalBloc {
  final DbApi dbApi;
  final bool add;
  final Journal selectedJournal;

  EditJournalBloc({
    this.add,
    this.selectedJournal,
    this.dbApi,
  }) {
    _startListeners();
  }

  StreamController<String> _dateController =
      StreamController<String>.broadcast();
  Sink<String> get dateChanged => _dateController.sink;
  Stream<String> get date => _dateController.stream;

  StreamController<String> _moodController =
      StreamController<String>.broadcast();
  Sink<String> get moodChanged => _moodController.sink;
  Stream<String> get mood => _moodController.stream;

  StreamController<String> _noteStreamController =
      StreamController<String>.broadcast();
  Sink<String> get noteChanged => _noteStreamController.sink;
  Stream<String> get note => _noteStreamController.stream;

  StreamController<String> _addOrUpdateJournalController =
      StreamController<String>();
  Sink<String> get addOrUpdateJournal => _addOrUpdateJournalController.sink;

  void _startListeners() {
    date.listen((date) {
      selectedJournal.date = date;
    });

    mood.listen((mood) {
      selectedJournal.mood = mood;
    });

    note.listen((note) {
      selectedJournal.note = note;
    });

    _addOrUpdateJournalController.stream.listen((event) {
      if (event == 'Save') {
        assert(selectedJournal.date != null);
        assert(selectedJournal.mood != null);
        assert(selectedJournal.note != null);
        _saveJournal();
      }
    });
  }

  void dispose() {
    _dateController.close();
    _moodController.close();
    _noteStreamController.close();
    _addOrUpdateJournalController.close();
  }

  void _saveJournal() {
    add
        ? dbApi.addJournal(selectedJournal)
        : dbApi.updateJournal(selectedJournal);
  }
}
