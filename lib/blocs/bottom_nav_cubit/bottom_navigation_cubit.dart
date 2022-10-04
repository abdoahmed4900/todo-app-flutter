// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../pages/archived_page.dart';
import '../../pages/done_page.dart';
import '../../pages/tasks_page.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit() : super(BottomNavigationInitial());

  static BottomNavigationCubit get(context) => BlocProvider.of(context);

  List pages = [const TasksPage(), const DonePage(), const ArchivedPage()];

  List<String> pageTitles = ['Tasks', 'Done', 'Archived'];

  int index = 0;

  void changeScreen(int index) {
    this.index = index;
    emit(BottomNavigationChange());
  }
}
