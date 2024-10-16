import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/data_sources/remote/fetch_todos.dart';
import 'package:myapp/infrastructure/models/todos.dart';
//Base uso provider https://www.youtube.com/watch?v=tuQ8j0IZI-0

class TodosProvider extends ChangeNotifier {
  Future<List<Todos>>? _todos = fetchTodos();

  Future<List<Todos>>? get todos =>
      _todos; //El getter es el que voy a acceder dodos lados.

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
    _todos = fetchTodos();
    notifyListeners();
  }

  Future<void> toggle(int id, bool completed) async {
    List<Todos>? tempTodos = await _todos;
    if (tempTodos != null && id < tempTodos.length) {
      tempTodos[id].completed = completed;
      _todos = Future.value(tempTodos);
      notifyListeners();
    }
  }

  /* void add(Todos todoNueva) {
    
  } */
}
