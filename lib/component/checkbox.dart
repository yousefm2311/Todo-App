// ignore_for_file: unused_import

import 'package:flutter/material.dart';

import '../bloc/cubit.dart';


class CheckBoxChange extends StatefulWidget {
  const CheckBoxChange({super.key});
  @override
  State<CheckBoxChange> createState() => _CheckBoxChangeState();
}

class _CheckBoxChangeState extends State<CheckBoxChange> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      onChanged: (bool? value) {
        AppCubit.get(context).changeText();
        setState(() {
          AppCubit.get(context).check = value;
        });
      },
      value: AppCubit.get(context).check,
    );
  }
}
