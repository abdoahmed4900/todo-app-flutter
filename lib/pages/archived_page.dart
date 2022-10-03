import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/database_cubit/database_cubit.dart';
import '../widgets/widgets.dart';

class ArchivedPage extends StatelessWidget {
  const ArchivedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DatabaseCubit, DatabaseState>(
      listener: (context, state) {
        if (state is TaskArchived) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Task Archived'),
            duration: Duration(milliseconds: 400),
          ));
        } else if (state is TaskDone) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Task Done'),
            duration: Duration(milliseconds: 400),
          ));
        }
      },
      builder: (context, state) {
        final tasksCubit = DatabaseCubit.cubit(context);
        List tasks = tasksCubit.archivedTasks;
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
              index: index,
              tasks: tasks,
              taskTitle: tasks[index]['title'],
              taskTime: tasks[index]['time'],
              taskDay: tasks[index]['day'],
              isScreenArchived: true,
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
