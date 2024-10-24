// To parse this JSON data, do
//
// final todos = todosFromJson(jsonString);
// app.quicktype.io

// import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

/* import 'package:flutter/foundation.dart'; */

// part 'todos.g.dart';

List<Todos> todosFromJson(String str) =>
    List<Todos>.from(json.decode(str).map((x) => Todos.fromJson(x)));

String todosToJson(List<Todos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

bool convertToBool(dynamic value) {
  if (value is int) {
    /* if (kDebugMode) {
      print('Value is int: $value');
    }
    if (kDebugMode) {
      print(value == 1);
    } */
    return value == 1;
  } else if (value is bool) {
    /* if (kDebugMode) {
      print('Value is bool: $value');
    } */
    return value;
  } else {
    // Manejar valores inesperados, por ejemplo, lanzar una excepción
    throw ArgumentError('Invalid value for completed: $value');
  }
}

// @JsonSerializable()//https://docs.flutter.dev/data-and-backend/serialization/json?gad_source=1&gclid=CjwKCAjwvKi4BhABEiwAH2gcw0visVoXRvDYrKC-8hHE3lypkUBBKO5l4qHpLJ97D2HkdC1I3bHEWxoCRZ4QAvD_BwE&gclsrc=aw.ds
class Todos {


  int id;
  String title;
  bool completed;
  int userId;
  int? sharedWithId;

  Todos({
    required this.id,
    required this.title,
    required this.completed,
    required this.userId,
    required this.sharedWithId,
  });

  factory Todos.fromJson(Map<String, dynamic> json) => Todos(
        id: json["id"],
        title: json["title"],
        completed: convertToBool(json["completed"]),
        userId: json["user_id"],
        sharedWithId: json["shared_with_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "completed": completed,
        "user_id": userId,
        "shared_with_id": sharedWithId,
      };

  Map<String, dynamic> toNewJson() => {
        "user_id": userId,
        "title": title,
      };

  Map<String, dynamic> toDelJson() => {
        "id": id,
      };
}
