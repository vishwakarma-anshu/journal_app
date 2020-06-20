class Journal {
  String documentId;
  String uid;
  String mood;
  String note;
  String date;

  Journal({
    this.date,
    this.mood,
    this.note,
    this.documentId,
    this.uid,
  });

  factory Journal.fromDoc(dynamic doc) => Journal(
        documentId: doc.documentID,
        uid: doc['uid'],
        date: doc['date'],
        note: doc['note'],
        mood: doc['mood'],
      );
}
