// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_sheet_state.dart';

class BottomSheetCubit extends Cubit<BottomSheetState> {
  bool isSheetOpened = false;
  BottomSheetCubit() : super(BottomSheetInitial());

  static BottomSheetCubit get(context) => BlocProvider.of(context);

  void changeBottomSheet(bool isChanged) {
    isSheetOpened = isChanged;
    emit(BottomSheetChanged());
  }
}
