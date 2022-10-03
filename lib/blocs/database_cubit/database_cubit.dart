// ignore_for_file: depend_on_referenced_packages, avoid_function_literals_in_foreach_calls

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/blocs/bottom_nav_cubit/bottom_navigation_cubit.dart';
import 'package:to_do_app/models/task.dart';

part 'database_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseCubit() : super(DatabaseLoading());

  late Database database;

  List<Map<String, dynamic>> newTasks = [];

  List<Map<String, dynamic>> archivedTasks = [];

  List<Map<String, dynamic>> doneTasks = [];

  static DatabaseCubit cubit(context) => BlocProvider.of(context);

  Future<Database> initializeDatabase() async {
    String path = await getDatabasesPath();

    doneTasks = [];

    archivedTasks = [];

    database =
        await openDatabase(join(path, 'tasks.db'), onCreate: (db, version) {
      db.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, time TEXT, day TEXT, status TEXT)',
      );
    }, onOpen: (db) {
      getTasks(database: db, status: 'new').then((value) => newTasks = value);
      getTasks(database: db, status: 'done').then((value) => doneTasks = value);
      getTasks(database: db, status: 'archived')
          .then((value) => archivedTasks = value);
    }, version: 1);

    emit(DatabaseCreated());

    return database;
  }

  void insertTask(
    Task task,
  ) async {
    await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO tasks(title,time,day,status) VALUES (?,?,?,?)',
          [task.title, task.time, task.day, 'new']);
    });
    newTasks = await getTasks(database: database, status: 'new');
    emit(TaskInserted());
  }

  void updateTask(
      {required int id,
      required String status,
      required BuildContext? context}) async {
    int index = BottomNavigationCubit.get(context).index;

    await database
        .rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [status, id]);
    if (status == 'archived') {
      if (index == 0) {
        newTasks = await getTasks(database: database, status: 'new');
      } else {
        doneTasks = await getTasks(database: database, status: 'done');
      }
      archivedTasks = await getTasks(database: database, status: 'archived');
      emit(TaskArchived());
    } else if (status == 'done') {
      if (index == 0) {
        newTasks = await getTasks(database: database, status: 'new');
      } else {
        archivedTasks = await getTasks(database: database, status: 'archived');
      }
      doneTasks = await getTasks(database: database, status: 'done');
      emit(TaskDone());
    }
  }

  Future getTasks({required Database database, required String status}) async {
    return await database
        .query('tasks', where: 'status = ?', whereArgs: [status]);
  }

  void deleteTask({required int id, required BuildContext context}) async {
    int index = BottomNavigationCubit.get(context).index;
    await database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
    if (index == 0) {
      getTasks(database: database, status: 'new');
    } else if (index == 1) {
      getTasks(database: database, status: 'done');
    } else {
      getTasks(database: database, status: 'archived');
    }
    emit(TaskDeleted());
  }
}
