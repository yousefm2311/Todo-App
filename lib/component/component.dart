// ignore_for_file: sort_child_properties_last, unnecessary_this
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../bloc/cubit.dart';
import '../bloc/statte.dart';
import 'checkbox.dart';

Widget titleTask(Map model, {required TextStyle style}) =>
    BlocConsumer<AppCubit, AppState>(builder: (context, state) {
      AppCubit cubit = AppCubit.get(context);
      return Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 10.0, bottom: 2.0, top: 10.0),
        child: Slidable(
          endActionPane: ActionPane(
            children: [
              SlidableAction(
                onPressed: (value) {
                  cubit.deleteDatabase(id: model['id']);
                },
                icon: Icons.delete,
                backgroundColor: Colors.red,
                borderRadius: BorderRadius.circular(15.0),
              )
            ],
            motion: const StretchMotion(),
          ),
          child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Edit task'),
                      actions: [
                        MaterialButton(
                          color: Colors.cyan,
                          onPressed: () {
                            cubit.updateDatabase(
                                title: cubit.editTitleController.text,
                                id: model['id']);
                          },
                          child: Text("Save"),
                        )
                      ],
                      content: TextFormField(
                        controller: cubit.editTitleController,
                        decoration: const InputDecoration(
                          hintText: 'Edit Task',
                        ),
                      ),
                    );
                  });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text(
                  '${model["title"]}'.capitalize(),
                  style: style),
                ),
                //trailing: const CheckBoxChange(),
              ),
            ),
          ),
      );
    }, listener: (context, state) {
      if (state is AppUpdateDatabase) {
        Navigator.pop(context);
      }
    });

extension MyExternsion on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
