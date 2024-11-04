import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/data_sources/bd_op.dart';
import 'package:myapp/infrastructure/models/todos.dart';
import 'package:myapp/providers/active_todo_provider.dart';
import 'package:myapp/providers/todos_provider.dart';
import 'package:myapp/widgets/trad_view.dart';
import 'package:provider/provider.dart';

Card taskCard(BuildContext context, Todos todo, int indexTodo) {
  /* int idDeTodo = todo.id; */
  bool isCompleted = todo.completed;

  final txtFldEditController = TextEditingController();
  if (todo.title != "") {
    txtFldEditController.text = todo.title;
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
    margin:
        const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 0.0),
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
        trailing: IconButton(
          //TODO borrar esto que dejo de ejemplo, y hacer algo para editar que funcione bien.
          icon: const Icon(Icons.trending_up),
          onPressed: () {
            context.read<ActiveTodoProvider>().setActiveTodo(todo);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(
                    child: TradingViewChart(),
                  ),
                ),
              ),
              // TradingViewChart(),
            );
            /* showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text('BottomSheet'),
                        /* ElevatedButton(
                          child: const Text('Close BottomSheet'),
                          onPressed: () => Navigator.pop(context),
                        ), */
                      ],
                    ),
                  ),
                );
              },
            ); */
          },
        ),
        /* trailing: checkbox0, */
      ),
    ),
  );
}
