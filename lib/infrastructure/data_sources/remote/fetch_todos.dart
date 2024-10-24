import 'package:dio/dio.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/infrastructure/models/todos.dart';

Future<List<Todos>> fetchTodos({int usId = 1}) async {
  List<dynamic> tempData;
  List<Todos> todosData = [];
  final dio = Dio();
  dio.options.headers['Content-Type'] = 'application/json';

  // final response =
  //     await dio.get('http://eduardo.servemp3.com:8080/todos/$usId');
  final response = await dio.get('http://$url:8080/todos/$usId');

  if (response.statusCode == 200) {
    tempData = response.data.map((json) => Todos.fromJson(json)).toList();
    todosData = List<Todos>.from(tempData);

    return todosData;
  } else {
    throw Exception('Failed to load todos');
  }
}
