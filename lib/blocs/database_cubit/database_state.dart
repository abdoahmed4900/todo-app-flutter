part of 'database_cubit.dart';

@immutable
abstract class DatabaseState {}

class DatabaseLoading extends DatabaseState {}

class DatabaseCreated extends DatabaseState {}

class GetDatafromDB extends DatabaseState {}

class TaskInserted extends DatabaseState {}

class TaskDeleted extends DatabaseState {}

class TaskArchived extends DatabaseState {}

class TaskDone extends DatabaseState {}
