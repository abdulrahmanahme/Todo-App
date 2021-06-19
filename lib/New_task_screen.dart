import 'package:flutter/material.dart';
import 'package:todo/Cubit/Cubit.dart';
import 'package:todo/Cubit/States.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/done.dart';

class NewTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = TodoCubit.get(context).tasks;
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

// List<Map> tasks = [        ];

Widget buildTaskItem(Map modle, context) {
  return Dismissible(
    key: Key(modle['id'].toString()),
    onDismissed: (direction) {
      TodoCubit.get(context).deleteData(id: (modle['id']));
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text("${modle["time"]}"),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "${modle["title"]}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${modle["data"]}",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.check_box,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    TodoCubit.get(context)
                        .updateDate(status: 'done', id: modle['id']);
                  }),
              SizedBox(
                width: 5,
              ),
              IconButton(
                  icon: Icon(
                    Icons.archive,
                    color: Colors.black45,
                  ),
                  onPressed: () {
                    TodoCubit.get(context)
                        .updateDate(status: 'Archive', id: modle['id']);
                  }),
            ],
          )
        ],
      ),
    ),
  );
}
