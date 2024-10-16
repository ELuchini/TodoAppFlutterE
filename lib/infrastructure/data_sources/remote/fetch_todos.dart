import 'package:dio/dio.dart';
import 'package:myapp/infrastructure/models/todos.dart';

Future<List<Todos>> fetchTodos({int usId = 1}) async {
  List<dynamic> tempData;
  List<Todos> todosData = [];
  final dio = Dio();
  // final response = await dio.get('https://jsonplaceholder.typicode.com/todos');
  final response =
      await dio.get('http://eduardo.servemp3.com:8080/todos/$usId');

  if (response.statusCode == 200) {
    // print(response.data.toString());
    // print(response.data.runtimeType);
    // print(response.data[0].runtimeType);
    // print(response.data[0].toString());
    // todosData = response.data;
    // todosData = response.data.map((json) => Todos.fromJson(json)).toList();
    // todosData = tareasDesdeAPI.map((json) => Tarea.fromJson(json)).toList();
    tempData = response.data.map((json) => Todos.fromJson(json)).toList();
    todosData = List<Todos>.from(tempData);

    // todosData = Todos.fromJson(response.data.toString());

    //Usuario.fromJson(jsonDecode(response.body));
    return todosData;
  } else {
    throw Exception('Failed to load todos');
  }
}
