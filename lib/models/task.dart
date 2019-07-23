import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  Task({
    this.id,
    this.projectId,
    this.title,
    this.note = '',
    this.completed = false,
    this.reminder,
    this.dueDate,
    this.createdBy,
  });

  String id;
  String projectId;
  String title;
  String note;
  String createdBy;
  DateTime reminder;
  DateTime dueDate;
  bool completed;

  Task.clone(Task other)
      : id = other.id,
        projectId = other.projectId,
        title = other.title,
        completed = other.completed,
        reminder = other.reminder,
        dueDate = other.dueDate,
        createdBy = other.createdBy,
        note = other.note;

  Task.fromDocument(DocumentSnapshot doc, String taskId, String projectId)
      : id = taskId,
        projectId = projectId,
        title = doc['title'],
        completed = doc['completed'],
        reminder = doc['reminder']?.toDate(),
        dueDate = doc['dueDate']?.toDate(),
        createdBy = doc['createdBy'],
        note = doc['note'];

  Map<String, dynamic> toDocument() => {
        'title': title,
        'completed': completed ?? false,
        'note': note ?? '',
        'reminder': reminder,
        'dueDate': dueDate,
        'createdBy': createdBy
      };
}
