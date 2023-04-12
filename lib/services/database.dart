import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/todo_model.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addToDo(TodoModel model) async {
    try {
      await _firestore.collection('todos').doc().set(model.toMap());
    } catch (e) {
      // ignore: avoid_print
      print('Error in inserting');
    }
  }

  Stream<List<TodoModel>> todoStream() {
    return _firestore
        .collection('todos')
        .orderBy("dateCreated", descending: true)
        .snapshots()
        .map((query) {
      List<TodoModel> todoList = [];
      for (var snapshot in query.docs) {
        todoList.add(TodoModel.fromSnapShot(snapshot));
      }
      return todoList;
    });
  }

  Future<void> updateTodo({required String id, required bool isDone}) async {
    await _firestore.collection('todos').doc(id).update({"isDone": isDone});
  }

  Future<void> deleteTodo({required String id}) async {
    await _firestore.collection('todos').doc(id).delete();
  }
}
