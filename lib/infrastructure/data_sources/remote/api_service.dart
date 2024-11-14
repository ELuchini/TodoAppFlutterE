//Generado por V0.dev en implementación de autenticación. 11-11-24
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/infrastructure/models/todos.dart';
import 'package:myapp/utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> init() async {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'auth_token');
          options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  Future<Response> post(String path, dynamic data) async {
    return await _dio.post(path, data: data);
  }

  // Añade más métodos según sea necesario
  Future<List<Todos>> fetchTodos({int usId = uID}) async {
    List<dynamic> tempData;
    List<Todos> todosData = [];

    _dio.options.headers['Content-Type'] = 'application/json';

    // final response =
    //     await dio.get('http://eduardo.servemp3.com:$port/todos/$usId');
    final response = await _dio.get('$url:$port/todos/$usId');

    if (response.statusCode == 200) {
      tempData = response.data.map((json) => Todos.fromJson(json)).toList();
      todosData = List<Todos>.from(tempData);

      return todosData;
    } else {
      throw Exception('Failed to load todos');
    }
  }

  //Acá empieza lo que era bd_op.dart

  Future<bool> deleteTodo(todo) async {
    final response = await _dio.delete('$url:$port/todos/${todo.id}');
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

    final response = await _dio.put('$url:$port/todos/$id', data: data);

    if (response.statusCode == 200) {
      //print('Response: $response.data');
      return true;
    } else {
      throw Exception('Failed to set completed');
    }
  }

  Future<bool> addNewTask(BuildContext context, Todos todoNueva) async {
    var dataTodo = todoNueva.toNewJson();

    if (kDebugMode) {
      print(dataTodo.toString());
    }

    final response = await _dio.post(
      '$url:$port/todos',
      data: dataTodo,
    );

    if (response.statusCode == 201) {
      //responde 201 por CREADO.
      //Recargo.. aunque acá debería actualizar manual el valor de _todos en el provider.
      // ignore: use_build_context_synchronously
      //context.read<TodosProvider>().refresh();

      if (context.mounted) {
        // context.read<TodosProvider>().refresh();//TODO lo comento para ver si funciona sin ello, para evitar mov datos. 12-11-24
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea creada BD.'),
          ),
        );
      }
      return true;
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al crear la tarea BD.'),
          ),
        );
      }
      return false;
    }
  }

  Future<bool> updateTask(BuildContext context, Todos todoToUpdate) async {
    var dataTodo = todoToUpdate.toJson();
    if (kDebugMode) {
      print(dataTodo.toString());
    }

    final response = await _dio.put(
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
      return true;
    }
    return false;
  }
}
