// ignore_for_file: depend_on_referenced_packages, avoid_function_literals_in_foreach_calls

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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
      getAllTasks(db);
    }, version: 1);

    emit(DatabaseCreated());

    return database;
  }

  Future<void> getAllTasks(Database database) async {
    archivedTasks = [];

    newTasks = [];

    doneTasks = [];
    database
        .rawQuery('SELECT * FROM tasks')
        .then((tasks) => tasks.forEach((element) {
              if (element['status'] == 'new') {
                newTasks.add(element);
              } else if (element['status'] == 'done') {
                doneTasks.add(element);
              } else {
                archivedTasks.add(element);
              }
            }));
  }

  void insertTask(
    Task task,
  ) async {
    await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO tasks(title,time,day,status) VALUES (?,?,?,?)',
          [task.title, task.time, task.day, 'new']);
    });
    getAllTasks(database);
    emit(TaskInserted());
  }

  void updateTask({required int id, required String status}) async {
    await database
        .rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [status, id]);
    getAllTasks(database);
    if (status == 'archived') {
      emit(TaskArchived());
    } else if (status == 'done') {
      emit(TaskDone());
    }
  }

  void deleteTask(int id) async {
    await database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
    getAllTasks(database);
    emit(TaskDeleted());
  }
}
