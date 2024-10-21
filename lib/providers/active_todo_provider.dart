import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/models/todos.dart';

class ActiveTodoProvider extends ChangeNotifier {
  final Todos _activeTodo =
      Todos(userId: 1, id: -1, title: '', completed: false, sharedWithId: null);

  Todos get activeTodo => _activeTodo;
  int get aTodoId => activeTodo.id;
  bool get aTodoCompleted => activeTodo.completed;
  String get aTodoTitle => activeTodo.title;

  void setActiveTodo(Todos todo) {
    _activeTodo.id = todo.id;
    _activeTodo.title = todo.title;
    _activeTodo.completed = todo.completed;
    _activeTodo.sharedWithId = todo.sharedWithId;
    notifyListeners();
  }

  void toggleCompleted() {
    _activeTodo.completed = !_activeTodo.completed;
    notifyListeners();
  }

  void updateTitle(String newTitle) {
    _activeTodo.title = newTitle;
    notifyListeners();
  }
}
