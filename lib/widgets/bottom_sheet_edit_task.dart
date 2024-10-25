import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/providers/todos_provider.dart';
import 'package:provider/provider.dart';

import '../infrastructure/data_sources/bd_op.dart';
import '../infrastructure/models/todos.dart';

void modalBSEditTask(BuildContext context, Todos todoToEdit) {
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
                      todoToEdit.title = value;
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
                          /* ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cancelando...',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                duration: Duration(milliseconds: 500),
                              ),
                            ); */
                          await Future.delayed(
                              const Duration(milliseconds: 800));
                          Navigator.pop(context, "Cancelando...");
                        },
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (todoToEdit.title != "") {
                            addNewTask(context, todoToEdit);
                            context.read<TodosProvider>().refresh();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tarea creada.'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cancelando creación de tarea.'),
                              ),
                            );
                          }
                          // Future.delayed(const Duration(seconds: 3));
                          Timer(const Duration(seconds: 2), () {
                            /* setState(() {}); */
                            Navigator.pop(context, "");
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
      }).then((value) {
    if (value != "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value,
            /* 'Cancelando...', */
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        duration: const Duration(milliseconds: 4500),
      ));
    }
  });
}
