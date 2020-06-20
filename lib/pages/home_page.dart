import 'package:flutter/material.dart';
import 'package:journal/blocs/authenticaiton_bloc_provider.dart';
import 'package:journal/blocs/edit_journal_bloc.dart';
import 'package:journal/blocs/edit_journal_bloc_provider.dart';
import 'package:journal/blocs/home_bloc.dart';
import 'package:journal/blocs/home_bloc_provider.dart';
import 'package:journal/classes/date_formate.dart';
import 'package:journal/classes/mood_icon.dart';
import 'package:journal/models/journal.dart';
import 'package:journal/pages/edit_journal_page.dart';
import 'package:journal/services/db_firestore_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBlocProvider homeBlocProvier;

  HomeBloc homeBloc;

  @override
  void dispose() {
    super.dispose();
  }

  String _uid;
  MoodIcon _moodIcon = MoodIcon();
  FormatDate formatDate = FormatDate();

  @override
  Widget build(BuildContext context) {
    homeBlocProvier = HomeBlocProvider.of(context);

    homeBloc = homeBlocProvier.homeBloc;

    _uid = homeBlocProvier.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              AuthenticationBlocProvider.of(context)
                  .authenticationBloc
                  .logoutUser
                  .add(true);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        initialData: [],
        stream: homeBloc.getJournals,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return buildSeperatedListView(snapshot.data);
          } else {
            return Center(
              child: Text('Add Journal'),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.lightGreen.shade400,
        child: SizedBox(height: 54.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 18.0,
        child: Icon(Icons.add),
        onPressed: () {
          print('HomePage UID : $_uid');
          _addOrUpdateJournal(add: true, journal: Journal(uid: _uid));
        },
      ),
    );
  }

  Widget buildSeperatedListView(List<Journal> journals) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 18.0),
      itemCount: journals.length,
      itemBuilder: (BuildContext context, int index) {
        Journal _journal = journals[index];
        String _titleDate =
            formatDate.dateFormateShortMonthDayYear(_journal.date);
        return Dismissible(
          key: Key(_journal.documentId),
          background: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            color: Colors.red,
            alignment: Alignment.centerLeft,
            child: Icon(Icons.delete),
          ),
          secondaryBackground: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            color: Colors.red,
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete),
          ),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  formatDate.dateFormateShortDayNumber(_journal.date),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen,
                  ),
                ),
                Text(
                  formatDate.dateFormatShortDayName(_journal.date),
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            title: Text(
              _titleDate,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _journal.mood,
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  _journal.note,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            trailing: Transform(
              transform: Matrix4.identity()
                ..rotateZ(_moodIcon.getMoodRotation(_journal.mood)),
              alignment: Alignment.center,
              child: Icon(
                _moodIcon.getMoodIcon(_journal.mood),
                color: _moodIcon.getMoodColor(_journal.mood),
                size: 32.0,
              ),
            ),
            onTap: () {
              _addOrUpdateJournal(add: false, journal: _journal);
            },
          ),
          onDismissed: (direction) async {
            bool confirmDelete = await _confirmDeleteOfJournal();
            if (confirmDelete) {
              homeBloc.deleteJournal.add(_journal);
            } else {
              homeBloc.deleteJournal.add(_journal);
              homeBloc.addJournal.add(_journal);
            }
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0.0,
          color: Colors.grey,
        );
      },
    );
  }

  Future<bool> _confirmDeleteOfJournal() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Journal'),
          content: Text('Are you sure you would like to delete ?'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text(
                'DELETE',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
  }

  void _addOrUpdateJournal({bool add, Journal journal}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return EditJournalBlocProvider(
          editJournalBloc: EditJournalBloc(
            add: add,
            selectedJournal: journal,
            dbApi: DbFirestoreService(),
          ),
          child: EditJournalPage(),
        );
      }),
    );
  }
}
