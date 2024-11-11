import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/models/todos.dart';
import 'package:myapp/providers/active_todo_provider.dart';
import 'package:myapp/providers/todos_provider.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/widgets/bottom_sheet_edit_task.dart';
import 'package:myapp/widgets/task_card.dart';
import 'package:provider/provider.dart';

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
                  return RefreshIndicator(
                    onRefresh: () async {
                      // Perform data refresh operations here (e.g., fetch new data)
                      await Future.delayed(const Duration(
                          milliseconds: 200)); // Simulate a delay
                      // Update your data source (e.g., call a provider method to refresh)
                      todosProvider.refresh();
                    },
                    child: ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];

                        return taskCard(context, todo, index);
                      },
                    ),
                  );
                  /* return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return taskCard(context, todo, index);
                    },
                  ); */
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                late Todos todoNueva = Todos(
                    userId: uID,
                    id: -1,
                    title: '',
                    completed: false,
                    sharedWithId: null);
                modalBSEditTask(context, todoNueva);
              },
              tooltip: 'Nuevo',
              child: const Icon(Icons.add),
            ),
          );
        }));
  }

  //Card TarjetaTareas ubic.

  //Snackbar Cartel Bajo ubic (Dentro de la tarjeta)
  //Snackbar Eliminar tarea ubic (Dentro de la tarjeta)

  //Bs Edit Task ubic.
  //Delete todo Ubic.
}

//ToggleBD Ubic.
//addNewTask Ubic.

//para build el release: flutter build apk --release++
