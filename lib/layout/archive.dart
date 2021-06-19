import 'package:flutter/material.dart';
import 'package:todo/Cubit/Cubit.dart';
import 'package:todo/Cubit/States.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/New_task_screen.dart';
import 'package:todo/layout/done.dart';

class ArchiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = TodoCubit.get(context).archive;
        return tasks.length > 0
            ? ListView.separated(
                itemBuilder: (context, index) =>
                    buildTaskItem(tasks[index], context),
                separatorBuilder: (context, index) => Container(
                      padding: EdgeInsetsDirectional.only(
                        start: 30,
                      ),
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[300],
                    ),
                itemCount: tasks.length)
            : NoTasks();
      },
    );
  }
}


