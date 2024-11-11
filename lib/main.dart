// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

// import 'package:myapp/infrastructure/models/todos.dart';
import 'package:flutter/material.dart';
// import 'package:myapp/pages/auth/auth_page.dart';
import 'package:myapp/pages/home/main_page.dart';
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
      home: const MainPage(title: 'Todo Listo'),
      //home: const AuthPage(),
    );
  }
}

