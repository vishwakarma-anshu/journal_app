import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal/models/journal.dart';
import 'package:journal/services/database_api.dart';

class DbFirestoreService implements DbApi {
  final Firestore _firestore = Firestore.instance;

  final String _journalCollection = 'journals';
  final String _userCollection = 'users';

  @override
  Future<bool> addNewUser(String uid, String email, String password) async {
    await _firestore.collection(_userCollection).document(uid).setData({
      'email': email,
      'password': password,
    });
    DocumentReference _docRef =
        _firestore.collection(_userCollection).document(uid);
    return _docRef != null;
  }

  @override
  Stream<List<Journal>> getJournals(String uid) {
    return _firestore
        .collection(_journalCollection)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Journal> _journalsDoc = snapshot.documents.map((doc) {
        return Journal.fromDoc(doc);
      }).toList();

      _journalsDoc.sort((doc1, doc2) => doc2.date.compareTo(doc1.date));
      print('List of Journals : $_journalsDoc');
      return _journalsDoc;
    });
  }

  @override
  Future<bool> addJournal(Journal journal) async {
    DocumentReference _docRef =
        await _firestore.collection(_journalCollection).add({
      'uid': journal.uid,
      'mood': journal.mood,
      'note': journal.note,
      'date': journal.date,
    });
    _firestore.collection(_journalCollection).document(journal.uid);

    return _docRef != null;
  }

  @override
  void deleteJournal(Journal journal) async {
    return await _firestore
        .collection(_journalCollection)
        .document(journal.documentId)
        .delete()
        .catchError((error) {
      print('Error Deleting Document : $error');
    });
  }

  @override
  void updateJournal(Journal journal) async {
    return await _firestore
        .collection(_journalCollection)
        .document(journal.documentId)
        .updateData({
      'uid': journal.uid,
      'note': journal.note,
      'mood': journal.mood,
      'date': journal.date,
    }).catchError((error) {
      print('Error Updating Journal : $error');
    });
  }
}
