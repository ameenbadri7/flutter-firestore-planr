import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  User({
    @required this.id,
    @required this.email,
    this.displayName = '',
    this.photoURL = '',
  });

  String id;
  String email;
  String displayName;
  String photoURL;

  User.fromDocument(DocumentSnapshot doc, String userId)
      : id = userId,
        email = doc['email'],
        displayName = doc['displayName'] ?? '',
        photoURL = doc['photoURL'] ?? '';

  Map<String, dynamic> toDocument() => {
        'email': email,
        'displayName': displayName,
        'photoURL': photoURL,
      };
}
