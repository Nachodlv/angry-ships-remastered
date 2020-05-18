import 'package:flutter/material.dart';

class Message {
  final String text;
  final String userId;

  Message({@required this.text, @required this.userId});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(text: json['text'], userId: json['userId']);
  }
}