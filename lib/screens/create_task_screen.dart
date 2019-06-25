import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:simple_moment/simple_moment.dart';

import '../components/editable_text_field.dart';
import '../models/task.dart';
import '../services/database.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({
    Key key,
    this.projectId,
    this.userId,
  }) : super(key: key);

  final String projectId;
  final String userId;

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final Database db = Database();
  String title = '';
  DateTime dueDate;
  String note = '';

  @override
  void dispose() {
    if (title.isNotEmpty) {
      print('adding');
      db.addTask(
          widget.projectId, Task(title: title, dueDate: dueDate, note: note));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
//      height: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          color: Colors.grey[100],
        ),
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            EditableTextField(
              initialValue: '$title',
              isFocused: true,
              onSubmit: (String selectedTitle) {
                title = selectedTitle;
              },
              style: Theme.of(context).textTheme.title,
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Remind me'),
            ),
            Divider(),
            InkWell(
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  currentTime: dueDate,
                  theme: DatePickerTheme(
                    doneStyle: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onConfirm: (DateTime selectedDate) {
                    setState(() {
                      dueDate = selectedDate;
                    });
                  },
                );
              },
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(dueDate != null
                    ? '${Moment.now().from(dueDate)}'
                    : 'Add due date'),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'NOTES:',
                  style: Theme.of(context).textTheme.body2,
                ),
                InkWell(
                  onTap: () {
                    // TODO: Go to Notes Screen
                  },
                  child: Visibility(
                    visible: note.isNotEmpty,
                    child: Text(
                      'EDIT',
                      style: Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: note.isNotEmpty,
              child: Text(
                'This is the note, am just here for show',
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            Visibility(
              visible: note.isEmpty,
              child: InkWell(
                onTap: () {
                  // TODO: Go to Notes Screen
                },
                child: Container(
                  width: double.infinity,
                  child: DottedBorder(
                    color: Colors.grey,
                    gap: 3,
                    child: Center(child: Text('Tap to add')),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
