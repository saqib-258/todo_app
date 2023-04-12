import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/database.dart';
import 'package:todo_app/utils.dart';

class TodoController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  final _todos = <TodoModel>[].obs;
  final loadingStatus = LoadingStatus.loading.obs;
  List<TodoModel> get todos => _todos;

  Future<void> addTodo() async {
    if (textEditingController.text != "") {
      await Database().addToDo(TodoModel(
          todo: textEditingController.text, dateCreated: Timestamp.now()));
      textEditingController.clear();
    }
  }

  @override
  void onInit() {
    _todos.bindStream(Database().todoStream());
    once(
      _todos,
      (callback) {
        loadingStatus(LoadingStatus.completed);
      },
    );

    super.onInit();
  }
}
