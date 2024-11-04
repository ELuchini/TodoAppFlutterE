import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/data_sources/remote/fetch_todos.dart';
import 'package:myapp/infrastructure/models/todos.dart';
//Base uso provider https://www.youtube.com/watch?v=tuQ8j0IZI-0

class TodosProvider extends ChangeNotifier {
  Future<List<Todos>>? _todos = fetchTodos();

  Future<List<Todos>>? get todos =>
      _todos; //El getter es el que voy a acceder todos lados.

  Future<void> updateTodo(int id, String newTitle, bool newCompleted) async {
    //Tirada por Gemini on IDX... no le cambié nada porque se ve igual que lo que yo hacìa....
    //Pero esta anda......
    List<Todos>? tempTodos = await _todos;
    if (tempTodos != null) {
      final index = tempTodos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        tempTodos[index].title = newTitle;
        tempTodos[index].completed = newCompleted;
        _todos = Future.value(tempTodos); // Update provider data
        notifyListeners(); // Notify listeners
      }
    }
  }



  /* no sirven porque entrgan un tipo Future, que no funciona.
  Future<bool> Function(int) get todoCompleted => (int idTodo) async {
        List<Todos>? tempTodos = await _todos;
        if (tempTodos != null) {
          return tempTodos[idTodo].completed;
        }
        return false;
      };

  bool Function(int) get todoCompletedOk => (int idTodo) {
        List<Todos>? tempTodos = _todos as List<Todos>?;
        if (tempTodos != null) {
          return tempTodos[idTodo].completed;
        }
        return false;
      }; */

  // Todosprovider() {
  //   _todos = fetchTodos();
  // }

  Future<void> refresh() async {
    // Timer(duration: const Duration(milliseconds: 500)){//Between the new task send to db, and the refresh, maybe its no enought time. 
    //   _todos = fetchTodos();
    // }
    _todos = fetchTodos();
    notifyListeners();
  }

  Future<void> toggle(int id, bool completed) async {
    List<Todos>? tempTodos = await _todos;
    if (tempTodos != null && tempTodos[id].id != -1) {
      tempTodos[id].completed = completed;
      _todos = Future.value(tempTodos);
      notifyListeners();
    }
  }

//No le encuentro la vuelta......... No actualiza la Card.
  /* Future<void> updateTask(int id, String title) async {
    if (await todos != null) {
      for (Todos todo in await todos!) {
        if (todo.id == id) {
          todo.title = title;
          break;
        }
      }
    }
  } */

  /* void add(Todos todoNueva) {
    
  } */
}
