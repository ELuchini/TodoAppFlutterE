import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants.dart';

import '../models/todos.dart';

Future<bool> deleteTodo(todo) async {
  final dio = Dio();
  final response = await dio.delete('http://$url:8080/todos/${todo.id}');
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to delete todo');
  }
}

Future<bool> toggleBd({required int id, required bool completed}) async {
  final data = jsonEncode({
    'value': completed,
  });
  // final jsonData = jsonEncode(data);
  //print('Data es: $data Y id es: $id'); //Cuando usaba jsonData imprimía ese.

  final dio = Dio();
  final response = await dio.put('http://$url:8080/todos/$id', data: data);

  if (response.statusCode == 200) {
    //print('Response: $response.data');
    return true;
  } else {
    throw Exception('Failed to set completed');
  }
}

Future<void> addNewTask(BuildContext context, Todos todoNueva) async {
  var dataTodo = todoNueva.toNewJson();

  if (kDebugMode) {
    print(dataTodo.toString());
  }

  final dio = Dio();
  final response = await dio.post(
    'http://$url:8080/todos',
    data: dataTodo,
  );

  if (response.statusCode == 201) {
    //responde 201 por CREADO.

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarea creada BD.'),
        ),
      );
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al crear la tarea BD.'),
        ),
      );
    }
  }
}

Future<void> updateTask(BuildContext context, Todos todoToUpdate) async {
  var dataTodo = todoToUpdate.toJson();
  if (kDebugMode) {
    print(dataTodo.toString());
  }

  final dio = Dio();
  final response = await dio.put(
    'http://$url:8080/todos/${todoToUpdate.id}',
    data: dataTodo,
  );

  if (response.statusCode == 200) {
    //responde 200 por OK.

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarea actualizada BD.'),
        ),
      );
    }
  }
}
