// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit() : super(BottomNavigationInitial());

  static BottomNavigationCubit get(context) => BlocProvider.of(context);

  int index = 0;

  void changeScreen(int index) {
    this.index = index;
    emit(BottomNavigationChange());
  }
}
