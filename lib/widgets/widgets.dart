import 'package:flutter/material.dart';
import 'package:to_do_app/blocs/database_cubit/database_cubit.dart';

Widget taskTile(
    {Key? key,
    required String taskTitle,
    required String taskDay,
    required String taskTime,
    bool? isScreenArchived,
    required Function archiveTask,
    required Function checkTask,
    required List tasks,
    required int index,
    required BuildContext context}) {
  final tasksCubit = DatabaseCubit.cubit(context);
  return Dismissible(
    key: UniqueKey(),
    onDismissed: (dir) {
      tasksCubit.deleteTask(context: context, id: tasks[index]['id']);
    },
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.width / 11,
            child: Text(
              taskTime,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 6,
              child: Text(
                taskTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 80),
            Text(taskDay),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 4.5,
        ),
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 3.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.archive),
                  onPressed: () {
                    // we are in done tasks or new tasks
                    if (isScreenArchived == null || !isScreenArchived) {
                      archiveTask();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    // we are in new tasks or archived tasks
                    if (isScreenArchived == null || isScreenArchived) {
                      checkTask();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget taskFormField(
    {required String label,
    String? errorText,
    TextInputType? inputType,
    required IconData prefixIconData,
    ValueChanged? onChanged,
    required FormFieldValidator<String>? validator,
    Function()? onTap,
    required TextEditingController controller}) {
  return TextFormField(
    validator: validator,
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        label: Text(label),
        prefixIcon: Icon(prefixIconData),
        errorText: errorText),
    onChanged: onChanged,
    onTap: onTap,
    controller: controller,
  );
}
