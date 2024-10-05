// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'package:dio/dio.dart';
// import 'package:myapp/infrastructure/models/todos.dart';
import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Test EAL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
      ),
      home: const MyHomePage(title: 'Todo Test EAL'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  Future<List<dynamic>>? _todos;

  @override
  void initState() {
    super.initState();
    _todos = fetchTodos();
  }

  // void _incrementCounter() {
  //   getData();
  //   setState(() {
  //     _counter++;
  //   });
  // }

  //Peticiones http tut https://www.youtube.com/watch?v=ad7buTVMUek Flutter http get Fernando Herrera.
  // Future<void> getData() async {
  //   final response =
  //       await Dio().get('https://jsonplaceholder.typicode.com/todos');
  //   todos = Todos.fromJson(jsonDecode(response.data));

  //   setState(() {
  //     //Aviso a flutter que se actualizó el state.
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 148, 252, 30),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Todos'),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _todos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final todos = snapshot.data!;
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];

                  return Card(
                    elevation: 7,
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ListTile(
                      title: Text(todo['title']),
                      trailing: Checkbox(
                        value: todo['completed'],
                        onChanged: (value) {
                          // Handle checkbox change (optional)
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            // Display a loading indicator while waiting
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
// String cantDatos = 'Cant. Datos: ';
// String titulo = 'Titulo: ';

// if (todos != null) {
//   // cantDatos += todos!.length.toString();
//   cantDatos += "20";
//   titulo = todos!.title[0].toUpperCase() + todos!.title.substring(1);
// }

// return Scaffold(
//   appBar: AppBar(
//     backgroundColor: Theme.of(context).primaryColor,
//     title: Text(widget.title),
//   ),
//   body: Center(
//     child: ListView(
//       // mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),
//             const Text(
//               'Hoy: ',
//             ),
//             Text(
//               cantDatos, // '$todos' + 'hola',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//             Text(
//               titulo,
//               style: Theme.of(context).textTheme.headlineLarge,
//             ),
//           ],
//         ),
//         Divider(
//           color: Theme.of(context).primaryColor,
//           thickness: 2,
//         ),

//         // ListView.builder(
//         //     itemCount: pokemon?.abilities.length ?? 0,
//         //     itemBuilder: (context, index){
//         //       return ListTile(
//         //         title: Text(pokemon!.abilities[index].ability.name),
//         //       );
//         //     },
//         //   ),
//         Divider(
//           color: Theme.of(context).primaryColor,
//           thickness: 2,
//         ),
//       ],
//     ),
//   ),
//   floatingActionButton: Row(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       FloatingActionButton(
//         onPressed: () {
//           getData();
//         },
//         tooltip: 'Anterior',
//         child: const Icon(Icons.navigate_before_rounded),
//       ),
//       const SizedBox(width: 14),
//       FloatingActionButton(
//         onPressed: () {
//           getData();
//         },
//         tooltip: 'Siguiente',
//         child: const Icon(Icons.navigate_next_rounded),
//       ),
//     ],
//   ),
// );
// }
// }
//para build el release: flutter build apk --release

Future<List<dynamic>> fetchTodos() async {
  final dio = Dio();
  final response = await dio.get('https://jsonplaceholder.typicode.com/todos');

  if (response.statusCode == 200) {
    return response.data;
  } else {
    throw Exception('Failed to load todos');
  }
}
