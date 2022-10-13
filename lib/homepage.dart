// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/cubit.dart';
import 'bloc/statte.dart';
import 'component/checkbox.dart';
import 'component/component.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  var keyScafflod = GlobalKey<FormState>();

  var controllerTitle = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppState>(
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.cyan,
                elevation: 10.0,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Form(
                          key: keyScafflod,
                          child: AlertDialog(
                            title: Text("Add Task"),
                            actions: [
                              MaterialButton(
                                color: Colors.cyan,
                                onPressed: () {
                                  if (keyScafflod.currentState!.validate()) {
                                    cubit.InsertDatabase(
                                        title: controllerTitle.text);
                                  }
                                },
                                child: Text(
                                  'Save',
                                ),
                              )
                            ],
                            content: TextFormField(
                              decoration: InputDecoration(hintText: 'Add Task'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Is Empty';
                                }
                                return null;
                              },
                              controller: controllerTitle,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        );
                      });
                },
                child: Icon(Icons.add),
              ),
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.cyan,
                elevation: 0,
                title: const Text('ToDo APP', style: TextStyle(fontSize: 25)),
              ),
              backgroundColor: Colors.cyan,
              body: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.add_task_sharp,
                                size: 16.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                '${cubit.tasks.length} Task',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CheckBoxChange(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: ConditionalBuilder(
                              condition: cubit.tasks.isNotEmpty,
                              builder: (context) {
                                return ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return titleTask(cubit.tasks[index],
                                          style: cubit.style);
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox();
                                    },
                                    itemCount: cubit.tasks.length);
                              },
                              fallback: (context) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.task,
                                        size: 40.0,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text('No Tasks Yet',
                                          style: TextStyle(fontSize: 20.0))
                                    ],
                                  ),
                                );
                              })),
                    ),
                  ],
                ),
              ),
            );
          },
          listener: ((context, state) {
            if (state is AppInsertDatabase) {
              Navigator.pop(context);
            }
          }),
        ));
  }
}
