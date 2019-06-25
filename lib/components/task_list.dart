import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../models/task.dart';
import '../services/date_helper.dart';
import 'task_item.dart';

Map<String, List<Task>> getCategorizedTaskList(List<Task> tasks) {
  return {
    'Overdue':
        tasks.where((task) => DateHelper.isOverdue(task.dueDate)).toList(),
    'Today': tasks.where((task) => DateHelper.isToday(task.dueDate)).toList(),
    'Tomorrow':
        tasks.where((task) => DateHelper.isTomorrow(task.dueDate)).toList(),
    'UpComing':
        tasks.where((task) => DateHelper.isUpcoming(task.dueDate)).toList(),
    'Someday': tasks.where((task) => task.dueDate == null).toList(),
  };
}

class TaskList extends StatelessWidget {
  TaskList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Task> tasks = Provider.of<List<Task>>(context);
    if (tasks == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          Task task = tasks[tasks.length - index - 1];
          return TaskItem(task: task);
        },
      );
    }
  }
}

class CategorizedTaskList extends StatelessWidget {
  CategorizedTaskList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Task> tasks = Provider.of<List<Task>>(context);
    if (tasks == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final categorizedTasks = getCategorizedTaskList(tasks);
      return Expanded(
        child: ListView(
          children: categorizedTasks.keys.map((key) {
            return StickyHeaderTaskList(
              header: key,
              tasks: categorizedTasks[key],
            );
          }).toList(),
        ),
      );
    }
  }
}

class StickyHeaderTaskList extends StatelessWidget {
  StickyHeaderTaskList({
    Key key,
    @required this.header,
    @required this.tasks,
  }) : super(key: key);

  final String header;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: tasks.isNotEmpty,
      child: StickyHeader(
        header: Container(
          height: 50.0,
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: Text(
            header,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        content: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            Task task = tasks[tasks.length - index - 1];
            return TaskItem(task: task);
          },
        ),
      ),
    );
  }
}
