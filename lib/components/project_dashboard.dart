import 'package:flutter/material.dart';

import 'editable_text_field.dart';

class ProjectDashboard extends StatelessWidget {
  const ProjectDashboard({
    Key key,
    this.title,
    this.noOfTasks,
    this.noOfTasksCompleted,
    this.onTitleChange,
  }) : super(key: key);

  final String title;
  final int noOfTasks;
  final int noOfTasksCompleted;
  final Function onTitleChange;

  int getPercentage() {
    if (noOfTasks == 0) return 0;
    return ((noOfTasksCompleted / noOfTasks) * 100).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        onTitleChange == null
            ? Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.title,
              )
            : EditableTextField(
                initialValue: title,
                style: Theme.of(context).textTheme.title,
                onSubmit: onTitleChange,
              ),
        Text(
          '$noOfTasks Tasks',
        ),
        Visibility(
          visible: true,
          child: Row(
            children: <Widget>[
              Expanded(
                child: LinearProgressIndicator(
                  value: noOfTasks == 0 ? 0 : noOfTasksCompleted / noOfTasks,
                  backgroundColor: Colors.grey,
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '${getPercentage()}%',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
