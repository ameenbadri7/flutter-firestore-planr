import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/task.dart';
import '../screens/task_details_screen.dart';
import '../services/database.dart';

class TaskItem extends StatelessWidget {
  TaskItem({Key key, @required this.task}) : super(key: key);

  final Task task;
  final Database db = Database();

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            db.deleteTask(task);
          },
        ),
      ],
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.grey[400],
        value: task.completed,
        onChanged: (isCompleted) {
          db.updateTask(task, completed: isCompleted);
        },
        title: GestureDetector(
          onTap: () {
            if (!task.completed) {
              Scaffold.of(context).showBottomSheet((context) {
                return TaskDetailsScreen(task: task);
              });
            }
          },
          child: Text(
            task.title,
            style: Theme.of(context).textTheme.body1.copyWith(
                  color: task.completed ? Colors.grey[400] : Colors.black,
                  decoration: task.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
          ),
        ),
        secondary: Visibility(
          visible: task.completed,
          child: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.grey[400],
              size: 20,
            ),
            onPressed: () {
              db.deleteTask(task);
            },
          ),
        ),
      ),
    );
  }
}
