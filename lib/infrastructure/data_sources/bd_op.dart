import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/providers/todos_provider.dart';
import 'package:myapp/utils/constants.dart';
import 'package:provider/provider.dart';

import '../models/todos.dart';

Future<bool> deleteTodo(todo) async {
  final dio = Dio();
  final response = await dio.delete('$url:$port/todos/${todo.id}');
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
  final response = await dio.put('$url:$port/todos/$id', data: data);

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
    '$url:$port/todos',
    data: dataTodo,
  );

  if (response.statusCode == 201) {
    //responde 201 por CREADO.
    //Recargo.. aunque acá debería actualizar manual el valor de _todos en el provider.
    // ignore: use_build_context_synchronously
    context.read<TodosProvider>().refresh();

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
    '$url:$port/todos/${todoToUpdate.id}',
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
