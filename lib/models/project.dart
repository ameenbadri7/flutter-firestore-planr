import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Project {
  Project({
    this.id,
    @required this.title,
    this.createdBy,
    this.noOfTasks = 0,
    this.noOfTasksCompleted = 0,
  });

  String id;
  String title;
  String createdBy;
  int noOfTasks;
  int noOfTasksCompleted;

  Project.fromDocument(DocumentSnapshot doc, String projectId)
      : id = projectId,
        title = doc['title'],
        noOfTasks = doc['noOfTasks'],
        noOfTasksCompleted = doc['noOfTasksCompleted'],
        createdBy = doc['createdBy'];

  Map<String, dynamic> toDocument() => {
        'title': title,
        'noOfTasks': noOfTasks,
        'noOfTasksCompleted': noOfTasksCompleted,
        'createdBy': createdBy,
      };
}
