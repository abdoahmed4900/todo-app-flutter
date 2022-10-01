// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/database_cubit/database_cubit.dart';
import '../widgets/widgets.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DatabaseCubit, DatabaseState>(
      listener: (context, state) {
        if (state is TaskArchived) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Task Archived'),
            duration: Duration(milliseconds: 400),
          ));
        } else if (state is TaskDone) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Task Done'),
            duration: Duration(milliseconds: 400),
          ));
        }
      },
      builder: (context, state) {
        final tasksCubit = DatabaseCubit.cubit(context);
        final tasks = tasksCubit.newTasks;
        return ListView.separated(
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Divider(
              color: Colors.grey,
              thickness: 0.5,
            ),
          ),
          itemCount: tasksCubit.newTasks.length,
          itemBuilder: (context, index) => taskTile(
              tasks: tasks,
              index: index,
              taskTitle: tasks[index]['title'],
              taskTime: tasks[index]['time'],
              taskDay: tasks[index]['day'],
              archiveTask: () => tasksCubit.updateTask(
                  id: tasks[index]['id'], status: 'archived'),
              checkTask: () =>
                  tasksCubit.updateTask(id: tasks[index]['id'], status: 'done'),
              context: context,
              isScreenArchived: null),
        );
      },
    );
  }
}
