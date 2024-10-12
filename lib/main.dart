// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'package:dio/dio.dart';
// import 'package:myapp/infrastructure/models/todos.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/models/todos.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:myapp/providers/todos_provider.dart';

// void main() => runApp(const TareasE());
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodosProvider(),
      child: const TareasE(),
    ),
  );
}

class TareasE extends StatelessWidget {
  const TareasE({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Test EAL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
        useMaterial3: true,
      ),
      home: const MainPage(title: 'Todo Test EAL'),
    );
  }
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    super.key,
    required this.title,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // int _counter = 0;

  // Future<List<dynamic>>? _todos;

  // @override
  // void initState() {
  //   super.initState();
  //   _todos = fetchTodos();
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
          body: FutureBuilder<List<Todos>>(
            future: context.watch<TodosProvider>().todos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final todos = snapshot.data!;
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];

                    return tarjetasTareas(context, todo, index);
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}')); //FOR DEBUG.
                // return Center(// BUILD
                // child: Text('Error: ${snapshot.error.runtimeType}'));
              }
              // Display a loading indicator while waiting
              return const Center(child: CircularProgressIndicator());
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context
                  .read<TodosProvider>()
                  .refresh(); //Usa provider para actualizar.
            },
            tooltip: 'Actualizar',
            child: const Icon(Icons.add),
          ),
        ));
  }

  Card tarjetasTareas(BuildContext context, todo, indexTodo) {
    bool isCompleted = todo.completed;

    /* bool isCompleted =
        false; //En estas lineas agrego compatibilidad para campo completed boleano o "boleaano SQL" (entero 1-0).

    if (todo['completed'] is bool) {
      isCompleted = todo['completed'];
    } else if (todo['completed'] == 0) {
      isCompleted = false;
    } else {
      isCompleted = true;
    } */

    var checkbox0 = Checkbox(
      value: isCompleted,
      onChanged: (value) async {
        if (await toggle(id: todo.id, completed: value!)) {
          setState(() {
            context.read<TodosProvider>().toggle(indexTodo, value);
            // todo['completed'] = value;
          });
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   cartelBajo(todo),
        // );
      },
    );
    return Card(
      color: Theme.of(context).cardTheme.surfaceTintColor,
      clipBehavior: Clip
          .hardEdge, //Sigo los datos de un ejemplo de tarjeta que viene en flutter y es cliqueable. Esto limita la animación del InkWell al tocar la tarjeta.
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
        onLongPress: () {},
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
                  title: Text(todo.title),
                  trailing: checkbox0,
                ),
                const SizedBox(height: 200.0),
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
          title: Text(todo.title),
          trailing: checkbox0,
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
          // Text(todo['title'] + ' - Usuario: ' + todo['user_id'].toString()),
          Text(todo.title + ' - Usuario: ' + todo.user_id.toString()),
    );
  }
}

Future<bool> toggle({required int id, required bool completed}) async {
  final data = jsonEncode({
    'value': completed,
  });
  // final jsonData = jsonEncode(data);
  //print('Data es: $data Y id es: $id'); //Cuando usaba jsonData imprimía ese.

  final dio = Dio();
  final response =
      await dio.put('http://eduardo.servemp3.com:8080/todos/$id', data: data);

  if (response.statusCode == 200) {
    //print('Response: $response.data');
    return true;
  } else {
    throw Exception('Failed to set completed');
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
