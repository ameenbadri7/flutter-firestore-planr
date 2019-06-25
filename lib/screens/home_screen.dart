import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../components/editable_text_field.dart';
import '../components/project_dashboard.dart';
import '../components/task_list.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../screens/auth_screen.dart';
import '../screens/tasks_list_screen.dart';
import '../services/auth.dart';
import '../services/database.dart';

class HomeScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  final Database db = Database();

  @override
  Widget build(BuildContext context) {
    List<Project> projects = Provider.of<List<Project>>(context);
    User user = Provider.of<User>(context);
    final screenSize = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      child: projects == null || user == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  actions: <Widget>[
                    IconButton(
                      iconSize: 36,
                      padding: EdgeInsets.all(14),
                      onPressed: () async {
                        await auth.signOut();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return AuthScreen();
                        }));
                      },
                      icon: Icon(
                        Icons.power_settings_new,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 50),
                        Stack(
                          children: <Widget>[
                            ClipPath(
                              clipper: WaveClipperTwo(reverse: true),
                              child: Container(
                                height: 200,
                                width: screenSize.width,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Avatar(
                                    onUpload: () async {
                                      File avatar = await ImagePicker.pickImage(
                                          source: ImageSource.gallery);
                                      if (avatar != null)
                                        return db.saveUserAvatar(user, avatar);
                                    },
                                    photoURL: user.photoURL,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Hey, ',
                                        style:
                                            Theme.of(context).textTheme.title,
                                      ),
                                      Expanded(
                                        child: EditableTextField(
                                          initialValue: '${user.displayName}',
                                          onSubmit: (displayName) {
                                            db.updateUser(user,
                                                displayName: displayName);
                                          },
                                          style:
                                              Theme.of(context).textTheme.title,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '"Greate Things Never Come From Comfort Zone."',
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    '${formatDate(DateTime.now(), [
                                      M,
                                      ' ',
                                      dd,
                                      ', ',
                                      yyyy
                                    ])}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: screenSize.width * 0.05),
                          height: 175,
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    right: screenSize.width * 0.05),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: double.infinity, minWidth: 80),
                                  child: FloatingActionButton(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SimpleDialog(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        'What projects are you planning on performing?',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                      TextField(
                                                        autofocus: true,
                                                        onSubmitted: (title) {
                                                          if (title
                                                              .isNotEmpty) {
                                                            Project project =
                                                                Project(
                                                                    title:
                                                                        title);
                                                            db.addProject(
                                                                project);
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .title,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    shape: CircleBorder(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: projects.length,
                                  itemBuilder: (context, index) {
                                    Project project =
                                        projects[projects.length - index - 1];
                                    return Card(
                                      elevation: 2,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              ScaleRoute(
                                                page: StreamProvider<
                                                    List<Task>>.value(
                                                  value:
                                                      db.getTasks(project.id),
                                                  child: TaskListScreen(
                                                    projectId: project.id,
                                                  ),
                                                ),
                                              ));
                                        },
                                        child: Container(
                                          width: screenSize.width * 0.6,
                                          padding: EdgeInsets.all(20),
                                          child: ProjectDashboard(
                                            title: project.title,
                                            noOfTasks: project.noOfTasks,
                                            noOfTasksCompleted:
                                                project.noOfTasksCompleted,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Today',
                                style: Theme.of(context).textTheme.title,
                              ),
                              TaskList(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class Avatar extends StatefulWidget {
  const Avatar({
    Key key,
    @required this.onUpload,
    @required this.photoURL,
  }) : super(key: key);

  final Function onUpload;
  final String photoURL;

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Visibility(
          visible: isUploading,
          child: Container(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              strokeWidth: 10,
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(50),
          highlightColor: Theme.of(context).primaryColor,
          onTap: () async {
            setState(() {
              isUploading = true;
            });
            await widget.onUpload();
            setState(() {
              isUploading = false;
            });
          },
          child: Container(
            height: 100,
            width: 100,
            child: widget.photoURL.isEmpty
                ? Icon(
                    Icons.file_upload,
                    color: Colors.white,
                    size: 60.0,
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).primaryColor,
                    backgroundImage: NetworkImage(widget.photoURL),
                  ),
          ),
        ),
      ],
    );
  }
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: child,
              ),
        );
}
