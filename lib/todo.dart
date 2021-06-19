import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:todo/Cubit/States.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Cubit/Cubit.dart';

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  int counter = 0;
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  Database database;

  var controller = TextEditingController();
  // IconData fabIcon = Icons.edit;

  var controllerTime = TextEditingController();
  var controllerdata = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..CreateDatabase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {
          if (state is InsertDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'New Tasks',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            body: state is! GetDBLodingState
                ? cubit.widgetOpetion[cubit.counter]
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_rounded), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archive'),
              ],
              currentIndex: TodoCubit.get(context).counter,
              onTap: (int index) {
                TodoCubit.get(context).onItemTapped(index);
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // insertToDatabase();
                if (cubit.isbottomsheet) {
                  if (formkey.currentState.validate()) {
                    cubit.insertToDatabase(
                        title: controller.text,
                        data: controllerdata.text,
                        time: controllerTime.text);
                  }
                } else {
                  scaffoldkey.currentState
                      .showBottomSheet((context) => Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text_Form_Widget(
                                  keyboardType: TextInputType.name,
                                  prefixIcon: Icon(Icons.title),
                                  controller: controller,
                                  hintText: 'Task Title',
                                  lableText: 'Task',
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text_Form_Widget(
                                  keyboardType: TextInputType.datetime,
                                  controller: controllerTime,

                                  prefixIcon: Icon(Icons.watch_later_outlined),
                                  hintText: 'Task time',
                                  // lableText: 'Task',

                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      controllerTime.text =
                                          value.format(context).toString();
                                      print(controller.text);
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text_Form_Widget(
                                  keyboardType: TextInputType.name,
                                  controller: controllerdata,

                                  prefixIcon:
                                      Icon(Icons.calendar_today_rounded),
                                  hintText: 'calendar',
                                  // lableText: 'Task',

                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            // lastDate: DateTime.parse('2022-5-6'),
                                            // firstDate: DateTime(1900),
                                            lastDate: DateTime(2100))
                                        .then((value) {
                                      controllerdata.text =
                                          DateFormat.yMMMEd().format(value);
                                      // print(DateFormat.yMMMEd().format(value));
                                    });
                                  },
                                ),
                              ],
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetSatate(
                        isShow: false, iconData: Icons.edit);
                  });

                  cubit.changeBottomSheetSatate(
                      isShow: true, iconData: Icons.add);
                }
              },
              tooltip: 'Increment',
              child: Icon(cubit.fabIcon),
            ), // This tr
          );
        },
      ),
    );
  }
}

class Text_Form_Widget extends StatelessWidget {
  String lableText;
  String hintText;
  Widget prefixIcon;
  Function onTap;
  Function validator;
  TextInputType keyboardType;
  TextEditingController controller;
  Text_Form_Widget(
      {this.lableText,
      this.hintText,
      this.prefixIcon,
      this.onTap,
      this.validator,
      this.keyboardType,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        keyboardType: keyboardType,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          labelText: lableText,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 42,
            vertical: 20,
          ),
          fillColor: Colors.grey,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).cardColor),
            borderRadius: BorderRadius.circular(10),
            gapPadding: 10,
          ),
        ),
        onTap: onTap,
        controller: controller,
        validator: validator,
      ),
    );
  }
}
