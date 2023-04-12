import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  late String todo;
  late bool isDone;
  late Timestamp dateCreated;
  late String id;
  TodoModel(
      {required this.todo, this.isDone = false, required this.dateCreated});
  TodoModel.fromSnapShot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.id;
    todo = documentSnapshot["todo"];
    isDone = documentSnapshot["isDone"];
  }
  Map<String, dynamic> toMap() {
    return {"todo": todo, "isDone": isDone, "dateCreated": dateCreated};
  }
}
