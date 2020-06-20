import 'package:journal/models/journal.dart';

abstract class DbApi {
  /// Returns list of journal form the database.
  Stream<List<Journal>> getJournals(String uid);

  /// Used to add journal to the database.
  Future<bool> addJournal(Journal journal);

  /// Adds the user information to database when first created.
  Future<bool> addNewUser(String uid, String email, String password);

  /// Updates the existing journal in the database.
  void updateJournal(Journal journal);

  /// Deletes the journal from the database.
  void deleteJournal(Journal journal);
}
