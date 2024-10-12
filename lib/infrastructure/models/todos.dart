// To parse this JSON data, do
//
// final todos = todosFromJson(jsonString);
// app.quicktype.io

// import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

// part 'todos.g.dart';

List<Todos> todosFromJson(String str) =>
    List<Todos>.from(json.decode(str).map((x) => Todos.fromJson(x)));

String todosToJson(List<Todos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

bool convertToBool(dynamic value) {
  if (value is int) {
    print('Value is int: $value');
    print(value == 1);
    return value == 1;
  } else if (value is bool) {
    print('Value is bool: $value');
    return value;
  } else {
    // Manejar valores inesperados, por ejemplo, lanzar una excepción
    throw ArgumentError('Invalid value for completed: $value');
  }
}

// @JsonSerializable()//https://docs.flutter.dev/data-and-backend/serialization/json?gad_source=1&gclid=CjwKCAjwvKi4BhABEiwAH2gcw0visVoXRvDYrKC-8hHE3lypkUBBKO5l4qHpLJ97D2HkdC1I3bHEWxoCRZ4QAvD_BwE&gclsrc=aw.ds
class Todos {
  int? userId;
  int id;
  String title;
  bool completed;

  Todos({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todos.fromJson(Map<String, dynamic> json) => Todos(
        userId: json["userId"] as int?,
        id: json["id"],
        title: json["title"],
        completed: convertToBool(json["completed"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
      };

  /* factory Todos.fromJson(Map<String, dynamic> json) => _$TodosFromJson(json);
  Map<String, dynamic> toJson() => _$TodosToJson(this); */
}
