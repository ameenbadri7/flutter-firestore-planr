import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

import '../models/project.dart';
import '../models/task.dart';
import '../models/user.dart';
import 'auth.dart';

class Database {
  final _firestore = Firestore.instance;
  final AuthService auth = AuthService();
  static final Database _instance = Database.internal();

  factory Database() => _instance;

  Database.internal();

  Future<void> saveUserAvatar(User user, File avatar) async {
    final StorageTaskSnapshot downloadUrl = await FirebaseStorage.instance
        .ref()
        .child(user.id + '.jpg')
        .putFile(avatar)
        .onComplete;

    final String photoURL = await downloadUrl.ref.getDownloadURL();
    return updateUser(user, photoURL: photoURL);
  }

  Stream<User> getUser() {
    return Observable(auth.user).switchMap((user) {
      if (user != null) {
        return _firestore
            .collection('users')
            .document(user.uid)
            .snapshots()
            .map((doc) => User.fromDocument(doc, doc.documentID));
      } else {
        return Observable<User>.just(null);
      }
    });
  }

  Future<void> createUser(String userId, {String email, String displayName}) {
    User user = User(id: userId, email: email, displayName: displayName);
    return _firestore
        .collection('users')
        .document(userId)
        .setData(user.toDocument());
  }

  Future<void> updateUser(User user,
      {String email, String displayName, String photoURL}) {
    user.email = email ?? user.email;
    user.displayName = displayName ?? user.displayName;
    user.photoURL = photoURL ?? user.photoURL;
    return _firestore
        .collection('users')
        .document(user.id)
        .setData(user.toDocument());
  }

  Stream<List<Project>> getProjectsStream() {
    return Observable(auth.user).switchMap((user) {
      if (user != null) {
        return _firestore
            .collection('projects')
            .where('createdBy', isEqualTo: user.uid)
            .snapshots()
            .map((list) => list.documents
                .map((doc) => Project.fromDocument(doc, doc.documentID))
                .toList());
      } else {
        return Observable<List<Project>>.just(null);
      }
    });
  }

  Future<DocumentReference> addProject(Project project) async {
    FirebaseUser user = await auth.getUser;
    project.createdBy = user.uid;
    return _firestore.collection('projects').add(project.toDocument());
  }

  Future<void> deleteProject(String projectId) {
    return _firestore.collection('projects').document(projectId).delete();
  }

  Future<void> updateProject(Project project, {String title}) {
    project.title = title ?? project.title;

    return _firestore
        .collection('projects')
        .document(project.id)
        .setData(project.toDocument());
  }

  Stream<List<Task>> getTasks(String projectId) {
    return _firestore
        .collection('projects')
        .document(projectId)
        .collection('tasks')
        .snapshots()
        .map((list) => list.documents.map((doc) {
              String projectId = doc.reference.parent().parent().documentID;
              String taskId = doc.documentID;
              return Task.fromDocument(doc, taskId, projectId);
            }).toList());
  }

  Stream<List<Task>> getAllTasksDueToday(FirebaseUser user) {
    final now = DateTime.now();
    return _firestore
        .collectionGroup('tasks')
        .where('dueDate',
            isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day))
        .where('dueDate',
            isLessThan: DateTime(now.year, now.month, now.day + 1))
        .where('createdBy', isEqualTo: user.uid)
        .snapshots()
        .map((list) => list.documents.map((doc) {
              String projectId = doc.reference.parent().parent().documentID;
              String taskId = doc.documentID;
              return Task.fromDocument(doc, taskId, projectId);
            }).toList());
  }

  Future<DocumentReference> addTask(String projectId, Task task) async {
    FirebaseUser user = await auth.getUser;
    task.createdBy = user.uid;
    return _firestore
        .collection('projects')
        .document(projectId)
        .collection('tasks')
        .add(task.toDocument());
  }

  Future<void> updateTask(Task task,
      {String title, String note, bool completed, DateTime dueDate}) {
    task.title = title ?? task.title;
    task.note = note ?? task.note;
    task.completed = completed ?? task.completed;
    task.dueDate = dueDate ?? task.dueDate;
    return _firestore
        .collection('projects')
        .document(task.projectId)
        .collection('tasks')
        .document(task.id)
        .setData(task.toDocument());
  }

  Future<void> deleteTask(Task task) {
    return _firestore
        .collection('projects')
        .document(task.projectId)
        .collection('tasks')
        .document(task.id)
        .delete();
  }
}
