import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ignore_for_file: prefer_const_constructors

import '../blocs/database_cubit/database_cubit.dart';
import '../widgets/widgets.dart';

class DonePage extends StatelessWidget {
  const DonePage({Key? key}) : super(key: key);

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
        List tasks = tasksCubit.doneTasks;
        return ListView.separated(
          separatorBuilder: (context, index) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Divider(
              color: Colors.grey,
              thickness: 0.5,
            ),
          ),
          itemCount: tasks.length,
          itemBuilder: (context, index) => taskTile(
              tasks: tasks,
              index: index,
              taskTitle: tasks[index]['title'],
              taskTime: tasks[index]['time'],
              taskDay: tasks[index]['day'],
              isScreenArchived: false,
              archiveTask: () => tasksCubit.updateTask(
                  context: context, id: tasks[index]['id'], status: 'archived'),
              checkTask: () => tasksCubit.updateTask(
                  id: tasks[index]['id'], status: 'done', context: context),
              context: context),
        );
      },
    );
  }
}
