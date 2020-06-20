import 'package:flutter/material.dart';
import 'package:journal/blocs/edit_journal_bloc.dart';
import 'package:journal/blocs/edit_journal_bloc_provider.dart';
import 'package:journal/classes/date_formate.dart';
import 'package:journal/classes/mood_icon.dart';
import 'package:journal/models/journal.dart';

class EditJournalPage extends StatefulWidget {
  @override
  _EditJournalPageState createState() => _EditJournalPageState();
}

class _EditJournalPageState extends State<EditJournalPage> {
  EditJournalBlocProvider _editJournalBlocProvider;
  EditJournalBloc _editJournalBloc;

  TextEditingController _noteEditingController = TextEditingController();

  FormatDate _formatDate;
  MoodIcon _moodIcon;

  @override
  void initState() {
    super.initState();
    _noteEditingController.text = '';
    _formatDate = FormatDate();
    _moodIcon = MoodIcon();
  }

  @override
  void dispose() {
    _editJournalBloc.dispose();
    _noteEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _editJournalBlocProvider = EditJournalBlocProvider.of(context);
    _editJournalBloc = _editJournalBlocProvider.editJournalBloc;

    final Journal journal = _editJournalBloc.selectedJournal;
    _noteEditingController.text = journal.note ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Journal'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StreamBuilder(
                  initialData: journal.date ?? DateTime.now().toString(),
                  stream: _editJournalBloc.date,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    _editJournalBloc.dateChanged
                        .add(snapshot.data); // Makes sure the data is not null.
                    if (snapshot.hasData) {
                      return FlatButton(
                        padding: EdgeInsets.zero,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.calendar_today,
                              size: 22.0,
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              _formatDate
                                  .dateFormateShortMonthDayYear(snapshot.data),
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          String _pickerDate = await selectDate(snapshot.data);
                          _editJournalBloc.dateChanged.add(_pickerDate);
                        },
                      );
                    } else {
                      return Text('Something went wrong');
                    }
                  },
                ),
                const SizedBox(height: 12.0),
                StreamBuilder(
                  initialData: journal.mood ?? 'Satisfied',
                  stream: _editJournalBloc.mood,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    _editJournalBloc.moodChanged.add(snapshot.data);
                    if (snapshot.hasData) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<MoodIcon>(
                          value: _moodIcon.getMoodList()[_moodIcon
                              .getMoodList()
                              .indexWhere(
                                  (element) => element.title == snapshot.data)],
                          items: _moodIcon.getMoodList().map((mood) {
                            return DropdownMenuItem<MoodIcon>(
                              value: mood,
                              child: Row(
                                children: <Widget>[
                                  Transform(
                                    transform: Matrix4.identity()
                                      ..rotateZ(
                                        mood.rotation,
                                      ),
                                    child: Icon(
                                      mood.icon,
                                      color: mood.color,
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                  SizedBox(width: 14.0),
                                  Text(mood.title),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (selected) {
                            _editJournalBloc.moodChanged.add(selected.title);
                          },
                        ),
                      );
                    } else {
                      return Text('Something went wrong.');
                    }
                  },
                ),
                const SizedBox(height: 12.0),
                StreamBuilder(
                  initialData: journal.note ?? '',
                  stream: _editJournalBloc.note,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    _editJournalBloc.noteChanged.add(snapshot.data);
                    if (snapshot.hasData) {
                      return TextField(
                        controller: _noteEditingController,
                        textInputAction: TextInputAction.newline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.subject,
                            color: Colors.black54,
                          ),
                        ),
                        onChanged: _editJournalBloc.noteChanged.add,
                      );
                    } else {
                      return Text('Something went wrong.');
                    }
                  },
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.lightGreen,
                      child: Text('Save'),
                      onPressed: () {
                        _editJournalBloc.addOrUpdateJournal.add('Save');
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 14.0),
                    FlatButton(
                      color: Colors.grey[400],
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> selectDate(String selectedDate) async {
    DateTime _initialDate = DateTime.parse(selectedDate);
    final DateTime _pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (_pickedDate != null) {
      selectedDate = DateTime(
        _pickedDate.year,
        _pickedDate.month,
        _pickedDate.day,
        _pickedDate.hour,
        _pickedDate.minute,
        _pickedDate.second,
        _pickedDate.millisecond,
        _pickedDate.microsecond,
      ).toString();
    }
    return selectedDate;
  }
}
