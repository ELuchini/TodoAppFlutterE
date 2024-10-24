// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:math';

// import 'package:myapp/infrastructure/models/todos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/bs_edit_task.dart';
import 'package:myapp/infrastructure/data_sources/bd_op.dart';
import 'package:myapp/infrastructure/models/todos.dart';
import 'package:myapp/providers/active_todo_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
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

  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Theme.of(context),
        home: Consumer<TodosProvider>(builder: (context, todosProvider, child) {
          return Scaffold(
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
                return Text("AT: ${activeTodoProvider.aTodoId}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600));
              }),
            ),
            body: FutureBuilder<List<Todos>>(
              future: todosProvider.todos,
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
                  if (kDebugMode) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Center(
                        child: Text('Error: ${snapshot.error.runtimeType}'));
                  }

                  /* return Center(
                      child: Text('Error: ${snapshot.error}')); */ //FOR DEBUG.
                  /* return Center(
                    child: Text(
                        'Error: ${snapshot.error.runtimeType}')); */ //FOR BUILD
                }
                // Display a loading indicator while waiting
                return const Center(child: CircularProgressIndicator());
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
          );
        }));
  }

  Card tarjetasTareas(BuildContext context, todo, indexTodo) {
    /* int idDeTodo = todo.id; */
    bool isCompleted = todo.completed;

    final txtFldEditController = TextEditingController();
    if (todo.title != null) {
      txtFldEditController.text = todo.title;
    }

    var checkbox0 = Checkbox(
      value: isCompleted,
      onChanged: (value) async {
        if (await toggleBd(id: todo.id, completed: value!)) {
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
                  // leading: checkbox0,
                  title: TextField(
                      controller: txtFldEditController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tarea',
                      ),
                      autofocus: true,
                      /* onSubmitted: (value) {
                        if (todo.title != value && todo.title.isNotEmpty) {
                          todo.title = value;
                          updateTask(context, todo);
                        }
                        Navigator.pop(context);
                      }, */
                      onChanged: (value) {}),
                  /* trailing: checkbox0, */
                ),
                ElevatedButton(
                  onPressed: () {
                    if (todo.title != txtFldEditController.value.text &&
                        todo.title.isNotEmpty) {
                      todo.title = txtFldEditController.value.text;
                      context
                          .read<TodosProvider>()
                          .updateTodo(todo.id, todo.title, todo.completed);

                      updateTask(context, todo);
                      // TodosProvider().refresh();
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Actualizar"),
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
          leading: checkbox0,
          title: Text(todo.title),
          trailing: IconButton( //TODO borrar esto que dejo de ejemplo, y hacer algo para editar que funcione bien.
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.read<ActiveTodoProvider>().setActiveTodo(todo);
              modalBSEditTask(context, todo);
            },
          ),
          /* trailing: checkbox0, */
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
            "¿Querés eliminar la tarea?: \n${context.read<ActiveTodoProvider>().activeTodo.title.substring(0, min(context.read<ActiveTodoProvider>().activeTodo.title.characters.length, 25))}...",
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

  //Bs Edit Task ubic.
  //Delete todo Ubic.
}

//ToggleBD Ubic.
//addNewTask Ubic.

//para build el release: flutter build apk --release++
