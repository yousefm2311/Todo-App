// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testcheckbox/bloc/statte.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitional());

  static AppCubit get(context) => BlocProvider.of(context);
  bool? check = false;

  void changeCheckBox(bool? Value) {
    check = Value;
    emit(AppCheckBox());
  }

  var editTitleController = TextEditingController();
  List<Map> tasks = [];
  late Database database;
  var style=TextStyle(fontSize: 22.0);
  void changeText() {
    style = TextStyle(
      fontSize: 22.0,
      decoration: check == false ? TextDecoration.lineThrough : null,
    ) ;
    emit(AppCheckTrue());
  }

  void createDatabase() {
    openDatabase('todo1.db', version: 1, onCreate: ((database, version) {
      print('Create Database');
      database
          .execute("CREATE TABLE task(id INTEGER PRIMARY KEY,title TEXT)")
          .then((value) {
        print('Create Table');
      }).catchError((error) {
        print("$error Erro create table");
      });
    }), onOpen: ((database) {
      getDatabase(database);
      print('Open Database');
    })).then((value) {
      database = value;
      emit(AppCreateDatabase());
    });
  }

  InsertDatabase({required String title}) async {
    await database.transaction((txn) async {
      txn.execute("INSERT INTO task(title) VALUES ('$title')").then((value) {
        getDatabase(database);
        emit(AppInsertDatabase());
        print("Insert Database");
      });
    }).catchError((error) {
      print("$error Insert");
    });
  }

  void getDatabase(database) async {
    database.rawQuery("SELECT * FROM task").then((value) {
      emit(AppGetDatabase());
      print(value);
      tasks = value;
    });
  }

  void deleteDatabase({required int id}) {
    database.rawDelete("DELETE FROM task WHERE id=? ", [id]).then((value) {
      getDatabase(database);
      emit(AppDeleteDatabase());
    });
  }

  void updateDatabase({required String title, required int id}) {
    database.rawUpdate("UPDATE task SET title=? WHERE id=?", [title, id]).then(
        (value) {
      getDatabase(database);
      emit(AppUpdateDatabase());
    });
  }
}
