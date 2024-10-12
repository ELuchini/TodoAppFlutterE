import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/data_sources/remote/fetch_todos.dart';
import 'package:myapp/infrastructure/models/todos.dart';
//Base uso provider https://www.youtube.com/watch?v=tuQ8j0IZI-0

class TodosProvider extends ChangeNotifier {
  Future<List<Todos>>? _todos = fetchTodos();

  Future<List<Todos>>? get todos =>
      _todos; //El getter es el que voy a acceder dodos lados.

  // Todosprovider() {
  //   _todos = fetchTodos();
  // }

  void refresh() {
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
}
