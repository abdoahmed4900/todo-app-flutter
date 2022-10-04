// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'blocs/bottom_nav_cubit/bottom_navigation_cubit.dart';
import 'blocs/bottom_sheet_cubit/bottom_sheet_cubit.dart';
import 'blocs/database_cubit/database_cubit.dart';
import 'blocs/observer.dart';
import 'models/task.dart';
import 'widgets/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DatabaseCubit()..initializeDatabase(),
        ),
        BlocProvider(
          create: (context) => BottomNavigationCubit(),
        ),
        BlocProvider(
          create: (context) => BottomSheetCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(
          title: 'ToDoApp',
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  TextEditingController taskDateController = TextEditingController();
  TextEditingController taskTimeController = TextEditingController();
  TextEditingController taskNameController = TextEditingController();
  TextEditingController searchBarController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
      builder: (context, state) {
        final navCubit = BottomNavigationCubit.get(context);
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterFloat,
          key: scaffoldKey,
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 56),
            child: AppBar(
              automaticallyImplyLeading: false,
              title: Text(navCubit.pageTitles[navCubit.index]),
            ),
          ),
          body: navCubit.pages[navCubit.index],
          floatingActionButton: Builder(builder: (context) {
            return BlocBuilder<BottomSheetCubit, BottomSheetState>(
              builder: (context, state) {
                final sheetCubit = BottomSheetCubit();
                return FloatingActionButton(
                  onPressed: () {
                    if (!sheetCubit.isSheetOpened) {
                      scaffoldKey.currentState!
                          .showBottomSheet((context) => openSheet(context))
                          .closed
                          .then((value) {
                        sheetCubit.changeBottomSheet(false);
                      });
                      sheetCubit.changeBottomSheet(true);
                    } else {
                      if (formKey.currentState!.validate()) {
                        Task task = Task(
                          title: taskNameController.value.text,
                          time: taskTimeController.value.text,
                          day: taskDateController.value.text,
                        );
                        Navigator.pop(context);
                        DatabaseCubit.cubit(context).insertTask(task);
                        sheetCubit.changeBottomSheet(false);
                      }
                    }
                  },
                  tooltip: 'Add Task',
                  child: const Icon(Icons.add),
                );
              },
            );
          }),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 8,
            backgroundColor: Colors.grey[300],
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
              BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive), label: 'Archived'),
            ],
            currentIndex: navCubit.index,
            onTap: (index) => navCubit.changeScreen(index),
          ),
        );
      },
    );
  }

  Widget openSheet(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      elevation: 20,
      builder: (context) => Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: taskFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name Should Not Be Empty';
                        }
                        return null;
                      },
                      controller: taskNameController,
                      label: 'Enter Task Name',
                      prefixIconData: Icons.title)),
              Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: taskFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Date Should Not Be Empty';
                        }
                        return null;
                      },
                      controller: taskDateController,
                      prefixIconData: Icons.date_range,
                      label: 'Select Task Date',
                      onTap: (() {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2025))
                            .then((value) => value != null
                                ? taskDateController.text =
                                    DateFormat().add_yMMMd().format(value)
                                : null);
                      }))),
              Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: taskFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Time Should Not Be Empty';
                      }
                      return null;
                    },
                    onTap: (() {
                      showTimePicker(
                              context: context, initialTime: TimeOfDay.now())
                          .then((value) => value != null
                              ? taskTimeController.text = value.format(context)
                              : null);
                    }),
                    controller: taskTimeController,
                    label: 'Select Task Time',
                    prefixIconData: Icons.watch,
                  )),
            ],
          ),
        ),
      ),
      onClosing: () {},
    );
  }
}
