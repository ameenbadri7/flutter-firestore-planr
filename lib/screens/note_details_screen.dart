import 'package:flutter/material.dart';

import '../components/editable_text_field.dart';

class NoteDetailScreen extends StatefulWidget {
  NoteDetailScreen({this.title, this.note});

  final String title;
  final String note;

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  String editedNote;

  @override
  void initState() {
    editedNote = widget.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context, widget.note),
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text('Done'),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.pop(context, editedNote);
            },
          ),
        ],
        title: Column(
          children: <Widget>[
            Text(
              'Notes',
              style: Theme.of(context).textTheme.subtitle,
            ),
            Text(
              '${widget.title}',
              style: TextStyle(color: Colors.grey[500]),
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.05),
        child: EditableTextField(
          initialValue: widget.note,
          isFocused: true,
          textInputAction: TextInputAction.newline,
          onChanged: (note) {
            editedNote = note;
          },
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }
}
