import 'package:flutter/material.dart';
import 'package:web/models/message.dart';

class Room {
  final String id;
  final List<String> users;
  final List<Message> messages;
  final bool started;

  Room(
      {@required this.id,
      @required this.users,
      @required this.messages,
      @required this.started});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
        id: json['id'],
        users: new List<dynamic>.from(json['users']).map<String>((e) => e['userId']).toList(),
        messages: new List<dynamic>.from(json['messages'])
            .map((e) => Message.fromJson(e)).toList(),
        started: json['started']);
  }
}

