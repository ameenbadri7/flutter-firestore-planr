import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/project_dashboard.dart';
import '../components/task_list.dart';
import '../models/project.dart';
import '../services/database.dart';
import 'create_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  TaskListScreen({this.projectId});

  final String projectId;
  final Database db = Database();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final Project project = Provider.of<List<Project>>(context)
        .firstWhere((project) => project.id == projectId, orElse: () => null);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Tasks'),
            elevation: 0,
            actions: <Widget>[
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                onSelected: (selected) {
                  switch (selected) {
                    case 'delete':
                      {
                        db.deleteProject(project.id);
                        Navigator.of(context).pop();
                      }
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    )
                  ];
                },
              ),
            ],
          ),
          body: project == null
              ? Container() // TODO: Show data does not exist picture
              : Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                  child: Column(
                    children: <Widget>[
                      ProjectDashboard(
                        title: project.title,
                        noOfTasks: project.noOfTasks,
                        noOfTasksCompleted: project.noOfTasksCompleted,
                        onTitleChange: (newProjectTile) {
                          db.updateProject(project, title: newProjectTile);
                        },
                      ),
                      CategorizedTaskList(),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: screenSize.width * 0.1),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CreateTaskButton(projectId: projectId),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class CreateTaskButton extends StatelessWidget {
  const CreateTaskButton({
    Key key,
    @required this.projectId,
  }) : super(key: key);

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () {
        Scaffold.of(context).showBottomSheet((context) {
          return CreateTaskScreen(projectId: projectId);
        });
      },
      shape: CircleBorder(),
    );
  }
}
