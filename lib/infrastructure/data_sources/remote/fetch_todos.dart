// import 'package:dio/dio.dart';
// import 'package:myapp/utils/constants.dart';
// import 'package:myapp/infrastructure/models/todos.dart';

// Future<List<Todos>> fetchTodos({int usId = uID}) async {
//   List<dynamic> tempData;
//   List<Todos> todosData = [];
//   final dio = Dio();
//   dio.options.headers['Content-Type'] = 'application/json';

//   // final response =
//   //     await dio.get('http://eduardo.servemp3.com:$port/todos/$usId');
//   final response = await dio.get('$url:$port/todos/$usId');

//   if (response.statusCode == 200) {
//     tempData = response.data.map((json) => Todos.fromJson(json)).toList();
//     todosData = List<Todos>.from(tempData);

//     return todosData;
//   } else {
//     throw Exception('Failed to load todos');
//   }
// }



//SE VA A REEMPLAZAR POR API_SERVICE.DART QUE CONTENDRÁ TODOS LOS METODOS
//QUE SEGUN V0.DEV ES UNA BUENA PRACTICA, Y APARTE DE PASO AGREGA EL ENCABEZADO
//PARA AUTENTICAR. 