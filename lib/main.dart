import 'package:flutter/material.dart';
import 'package:todo/todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Cubit/BlocObserver.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Todo(),
      ),
    );
  }
}
