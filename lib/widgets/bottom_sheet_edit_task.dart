import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/data_sources/remote/api_service.dart';
import 'package:myapp/providers/todos_provider.dart';
import 'package:provider/provider.dart';

import '../infrastructure/models/todos.dart';

void modalBSNewTask(BuildContext context, Todos newTodo) {
  showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      sheetAnimationStyle: AnimationStyle(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeIn,
          reverseDuration: Duration(milliseconds: 500),
          reverseCurve: Curves.easeInOut),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tarea',
                      ),
                      onChanged: (value) {
                        newTodo.title = value;
                      },
                      onSubmitted: (value) {},
                      autofocus: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          /* ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cancelando...',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                duration: Duration(milliseconds: 500),
                              ),
                            ); */
                          /* await Future.delayed(
                              const Duration(milliseconds: 800)); */
                          Timer(const Duration(milliseconds: 1), () {
                            // Navigator.pop(context, "");
                          });
                          Navigator.pop(context, "Cancelando...");
                        },
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (newTodo.title != "") {
                            if (await ApiService()
                                .addNewTask(context, newTodo)) {
                              context
                                  .read<TodosProvider>()
                                  .addTodoOfline(newTodo);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error al crear la tarea.'),
                                ),
                              );
                            }
                            Timer(const Duration(milliseconds: 150), () {
                              Navigator.pop(context, "Tarea creada...");
                            });
                          } else {
                            Timer(const Duration(milliseconds: 150), () {
                              Navigator.pop(
                                  context, "Cancelando creación de tarea...");
                            });
                          }
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                  // Suggested code may be subject to a license. Learn more: ~LicenseLog:3471257838.
                ],
              ),
            ));
      }).then((value) {
    if (value != "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value,
            /* 'Cancelando...', */
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        duration: const Duration(milliseconds: 250),
      ));
    }
  });
}
