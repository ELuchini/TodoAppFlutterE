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
        colorSchemeSeed: Colors.greenAccent,
        useMaterial3: true,
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
        theme: Theme.of(context),
        home: Scaffold(
          backgroundColor: Theme.of(context).canvasColor, //Colors.white,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor, //Colors.blue,
            elevation: 5,
            shadowColor: Theme.of(context).shadowColor,
            title: const Text(
              'Tareas',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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

                    return tarjetasTareas(context, todo);
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              // Display a loading indicator while waiting
              return const Center(child: CircularProgressIndicator());
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                _todos = fetchTodos();
              });
            },
            tooltip: 'Actualizar',
            child: const Icon(Icons.add),
          ),
        ));
  }

  Card tarjetasTareas(BuildContext context, todo) {
    bool isCompleted = false;

    if (todo['completed'] is bool) {
      isCompleted = todo['completed'];
    } else if (todo['completed'] == 0) {
      isCompleted = false;
    } else {
      isCompleted = true;
    }

    return Card(
      color: Theme.of(context).cardTheme.surfaceTintColor,
      clipBehavior: Clip
          .hardEdge, //Sigo los datos de un ejemplo de tarjeta que viene en flutter y es cliqueable. Esto limita la animación al tocarla.
      elevation: 3,
      margin: const EdgeInsets.only(
          left: 10.0, right: 10.0, top: 10.0, bottom: 0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: InkWell(
        splashColor: Theme.of(context)
            .focusColor
            .withAlpha(40), //Colors.lightBlue.withAlpha(40),
        onTap: () {
          showModalBottomSheet(
            context: context,
            sheetAnimationStyle: AnimationStyle(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn),
            builder: (context) {
              // Using Wrap makes the bottom sheet height the height of the content.
              // Otherwise, the height will be half the height of the screen.
              return Wrap(children: [
                ListTile(
                  title: Text(todo['title']),
                  trailing: Checkbox(
                    value: isCompleted,
                    onChanged: (value) {
                      // Handle checkbox change (optional)
                      ScaffoldMessenger.of(context).showSnackBar(
                        cartelBajo(todo),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 300.0),
                ListTile(
                  title: const Text('Cerrar'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ]);
            },
          );

          // ScaffoldMessenger.of(context).showSnackBar(
          //   cartelBajo(todo),
          // );
        },
        child: ListTile(
          title: Text(todo['title']),
          trailing: Checkbox(
            value: isCompleted,
            onChanged: (value) {
              // Handle checkbox change (optional)
              ScaffoldMessenger.of(context).showSnackBar(
                cartelBajo(todo),
              );
            },
          ),
        ),
      ),
    );
  }

  SnackBar cartelBajo(todo) {
    return SnackBar(
      duration: const Duration(milliseconds: 400),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content:
          Text(todo['title'] + ' - Usuario: ' + todo['user_id'].toString()),
    );
  }
}

Future<List<dynamic>> fetchTodos({int usId = 1}) async {
  final dio = Dio();
  // final response = await dio.get('https://jsonplaceholder.typicode.com/todos');
  final response =
      await dio.get('http://eduardo.servemp3.com:8080/todos/${usId}');

  if (response.statusCode == 200) {
    return response.data;
  } else {
    throw Exception('Failed to load todos');
  }
}


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
//para build el release: flutter build apk --release++
