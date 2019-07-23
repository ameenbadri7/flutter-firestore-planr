import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:simple_moment/simple_moment.dart';

import '../components/editable_text_field.dart';
import '../models/task.dart';
import '../services/database.dart';
import 'note_details_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({
    Key key,
    this.task,
  }) : super(key: key);

  final Task task;

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final Database db = Database();
  String title = '';
  DateTime reminder;
  DateTime dueDate;
  String note = '';

  @override
  void initState() {
    title = widget.task.title;
    reminder = widget.task.reminder;
    dueDate = widget.task.dueDate;
    note = widget.task.note;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: Extract this condition
    if (title.isNotEmpty &&
        ((title != widget.task.title) ||
            (dueDate != null && widget.task.dueDate == null) ||
            (widget.task.dueDate != null &&
                !(dueDate.isAtSameMomentAs(widget.task.dueDate))) ||
            (reminder != null && widget.task.reminder == null) ||
            (widget.task.reminder != null &&
                !(reminder.isAtSameMomentAs(widget.task.reminder))) ||
            note != widget.task.note)) {
      db.updateTask(widget.task,
          title: title, dueDate: dueDate, reminder: reminder, note: note);
    }
    super.dispose();
  }

  void openNoteDetailScreen() async {
    note =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NoteDetailScreen(
        title: title,
        note: note,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        Provider.of<FlutterLocalNotificationsPlugin>(context);
    return SingleChildScrollView(
      child: Container(
//        height: 500,
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
              onSubmit: (String selectedTitle) {
                title = selectedTitle;
              },
              style: Theme.of(context).textTheme.title,
            ),
            InkWell(
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  currentTime: reminder,
                  theme: DatePickerTheme(
                    doneStyle: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onConfirm: (DateTime selectedDate) async {
                    setState(() {
                      reminder = selectedDate;
                    });
                    // TODO: Fix Android Reminders
                    var scheduledNotificationDateTime = reminder;
                    var androidPlatformChannelSpecifics =
                        AndroidNotificationDetails(
                            'your other channel id',
                            'your other channel name',
                            'your other channel description');
                    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
                    NotificationDetails platformChannelSpecifics =
                        NotificationDetails(androidPlatformChannelSpecifics,
                            iOSPlatformChannelSpecifics);
                    await flutterLocalNotificationsPlugin.schedule(
                        0,
                        '$title',
                        'Lets get to working',
                        scheduledNotificationDateTime,
                        platformChannelSpecifics,
                        androidAllowWhileIdle: true);
                  },
                );
              },
              child: ListTile(
                leading: Icon(Icons.alarm),
                title: Text(reminder != null
                    ? '${Moment.now().from(reminder)}'
                    : 'Remind me'),
              ),
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
                  onTap: openNoteDetailScreen,
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
                '$note',
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            Visibility(
              visible: note.isEmpty,
              child: InkWell(
                onTap: openNoteDetailScreen,
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
