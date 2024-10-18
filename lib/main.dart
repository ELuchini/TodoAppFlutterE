// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
// import 'package:myapp/infrastructure/models/todos.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/models/todos.dart';
import 'package:myapp/providers/active_todo_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:myapp/providers/todos_provider.dart';

// void main() => runApp(const TareasE());
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodosProvider()),
        ChangeNotifierProvider(create: (context) => ActiveTodoProvider()),
      ],
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
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(0, 0, 50, 1),
        brightness: Brightness.dark,
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
            leading: Consumer<ActiveTodoProvider>(
                builder: (context, activeTodoProvider, child) {
              return Text(
                  "ATodo: ${context.read<ActiveTodoProvider>().aTodoId}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold));
            }),
          ),
          body: Consumer<TodosProvider>(
            builder: (context, todosProvider, child) {
              return FutureBuilder<List<Todos>>(
                future: TodosProvider().todos,
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
                    /* return Center(
                        child: Text(
                            'Error: ${snapshot.error.runtimeType}')); */ //FOR BUILD
                  }
                  // Display a loading indicator while waiting
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  late Todos todoNueva = Todos(
                      userId: 1,
                      id: -1,
                      title: '',
                      completed: false,
                      sharedWithId: null);
                  modalBSEditTask(context, todoNueva);
                },
                tooltip: 'Nuevo',
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 7),
              // SizedBox(width: 10)
              FloatingActionButton(
                onPressed: () {
                  context.read<TodosProvider>().refresh();
                }, //Usa provider para actualizar.
                tooltip: 'Actualizar',
                child: const Icon(Icons.refresh),
              ),
            ],
          ),

          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     context
          // .read<TodosProvider>()
          // .refresh(); //Usa provider para actualizar.
          //   tooltip: 'Actualizar',
          //   child: const Icon(Icons.refresh),
          // ),
        ));
  }

  Card tarjetasTareas(BuildContext context, todo, indexTodo) {
    /* int idDeTodo = todo.id; */
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
        /* print("En cambio, El Valor es: $value");
        print("y todo completed es: $todo.completed"); */
        if (await toggleBd(id: todo.id, completed: value!)) {
          /* setState(() {
            // context.read<TodosProvider>().toggle(indexTodo, value);
            // todo['completed'] = value;
          }); */
          /* print("prev read valor: $value y completed $todo.completed"); */
          if (context.mounted) {
            context.read<TodosProvider>().toggle(indexTodo, value);
            ScaffoldMessenger.of(context).showSnackBar(
              cartelBajo(todo),
            );
          }

          /* print("post read valor: $value y completed $todo.completed"); */
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error al actualizar el estado'),
              ),
            );
          }
        }
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
        borderRadius: BorderRadius.circular(25),
        onLongPress: () {
          final BuildContext contextLista = context;
          context.read<ActiveTodoProvider>().setActiveTodo(todo);
          ScaffoldMessenger.of(context).showSnackBar(
            eliminarTarea(contextLista),
          );
        },
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
          Center(
        child: Text(
          !todo.completed ? "Completado" : "Pendiente",
          style: TextStyle(
              fontSize: 20, color: !todo.completed ? Colors.green : Colors.red),
        ),
      ),
    );
  }

  SnackBar eliminarTarea(BuildContext currentContext) {
    /* print(
        'Eliminar tarea ${context.read<ActiveTodoProvider>().aTodoId.toString()}'); */
    return SnackBar(
      duration: const Duration(milliseconds: 2500),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Row(
        children: [
          Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
          Text(
            /* "¿Querés eliminar la tarea?: ${context.read<ActiveTodoProvider>().aTodoId}- ${context.read<ActiveTodoProvider>().activeTodo.title} ", */
            "¿Eliminas la tarea?: ${context.read<ActiveTodoProvider>().activeTodo.title.substring(0, min(context.read<ActiveTodoProvider>().activeTodo.title.characters.length, 18))}...",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'Eliminar',
        textColor: Colors.red,
        onPressed: () async {
          /* final BuildContext currentContext = context; */
          if (await deleteTodo(context.read<ActiveTodoProvider>().activeTodo)) {
            if (currentContext.mounted) {
              currentContext.read<TodosProvider>().refresh();
              ScaffoldMessenger.of(currentContext).showSnackBar(
                const SnackBar(
                  content: Text('Tarea eliminada.'),
                  duration: Duration(milliseconds: 500),
                ),
              );
            }
          } else {
            if (currentContext.mounted) {
              ScaffoldMessenger.of(currentContext).showSnackBar(
                const SnackBar(
                  content: Text('Error al eliminar la tarea.'),
                ),
              );
            }
          }

          /* Navigator.pop(context); //Comento porque me cerraba la pantalla principal.*/
        },
      ),
    );
  }

  void modalBSEditTask(BuildContext context, Todos todoNueva) {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        sheetAnimationStyle: AnimationStyle(
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn),
        builder: (context) {
          // Using Wrap makes the bottom sheet height the height of the content.
          // Otherwise, the height will be half the height of the screen.
          return Scaffold(
              appBar: AppBar(
                title: const Text('Nueva Tarea'),
              ),
              body: Center(
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tarea',
                      ),
                      onChanged: (value) {
                        todoNueva.title = value;
                      },
                      onSubmitted: (value) {},
                      autofocus: true,
                    ),
                    const SizedBox(
                      height: 10,
                      width: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cancelando...',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                duration: Duration(milliseconds: 500),
                              ),
                            );
                            await Future.delayed(
                                const Duration(milliseconds: 800));
                            Navigator.pop(context);
                          },
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (todoNueva.title != "") {
                              addNewTask(context, todoNueva);
                              context.read<TodosProvider>().refresh();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tarea creada.'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Cancelando creación de tarea.'),
                                ),
                              );
                            }
                            // Future.delayed(const Duration(seconds: 3));
                            Timer(const Duration(seconds: 2), () {
                              setState(() {});
                              Navigator.pop(context);
                            });
                            // Navigator.pop(context);
                          },
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                    // Suggested code may be subject to a license. Learn more: ~LicenseLog:3471257838.
                  ],
                ),
              ));
        });
  }

  Future<bool> deleteTodo(todo) async {
    final dio = Dio();
    final response =
        await dio.delete('http://eduardo.servemp3.com:8080/todos/${todo.id}');
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete todo');
    }
  }
}

Future<bool> toggleBd({required int id, required bool completed}) async {
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

Future<void> addNewTask(BuildContext context, Todos todoNueva) async {
  var dataTodo = todoNueva.toNewJson();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(dataTodo.toString()),
    ),
  );

  final dio = Dio();
  final response = await dio.post(
    'http://eduardo.servemp3.com:8080/todos',
    data: todoNueva.toNewJson(),
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
