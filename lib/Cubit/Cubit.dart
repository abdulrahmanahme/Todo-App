import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/Cubit/States.dart';
import 'package:todo/New_task_screen.dart';
import 'package:todo/layout/archive.dart';
import 'package:todo/layout/done.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(IntialTodoState());

  static TodoCubit get(context) => BlocProvider.of(context);
  int counter = 0;
  Database database;

  bool isbottomsheet = false;
  IconData fabIcon = Icons.edit;
  List<Map> tasks = [];
  List<Map> done = [];

  List<Map> archive = [];

  void onItemTapped(int index) {
    counter = index;
    emit(TappedState());
  }

  void changeBottomSheetSatate({
    @required bool isShow,
    @required IconData iconData,
  }) {
    isbottomsheet = isShow;
    fabIcon = iconData;
    emit(ChangeBottomSheetSatate());
  }

  List<Widget> widgetOpetion = [
    NewTaskScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];

  insertToDatabase({
    @required String title,
    @required String data,
    @required String time,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks (title ,data ,time ,status)VALUES("$title" ,"$data" ,"$time" ,"new")')
          .then(
        (value) {
          print('$value insert Succefuly');
          emit(InsertDataBaseState());

          getDatabase(database);
        },
      ).catchError((error) {
        print('When succefuly insert ${error.toString()}');
      });
      return null;
    });
  }

  void getDatabase(database) {
    tasks = [];
    done = [];
    archive = [];

    emit(GetDBLodingState());
    database.rawQuery('SELECT *FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          tasks.add(element);
        else if ((element['status'] == 'done'))
          done.add(element);
        else
          archive.add(element);
      });

      emit(GetDataBaseState());
    });
  }

  void CreateDatabase() {
    openDatabase(
      'Todo.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, data TEXT, time TEXT ,  status TEXT)')
            .then(
              (value) => print('db created'),
            )
            .catchError((error) {
          print('db open${error.toString()}');
        });
      },
      onOpen: (database) {
        getDatabase(database);
        print("open database");
      },
    ).then((value) {
      database = value;
      emit(CreateDataBaseState());
    });
  }

  void updateDate({
    @required String status,
    @required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id= ?', [
      '$status',
      id,
    ]).then((value) {
      getDatabase(database);
      emit(UpDateDatabaseState());
    });
  }

  void deleteData({
    @required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [
      id,
    ]).then((value) {
      getDatabase(database);
      emit(DeleteDatabaseState());
    });
  }
}
