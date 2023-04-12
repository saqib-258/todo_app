import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/todo_controller.dart';
import 'package:todo_app/services/database.dart';
import 'package:todo_app/utils.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TodoController controller = Get.put(TodoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  height: 330,
                  decoration: const BoxDecoration(color: Color(0xFF6d63ff)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 50, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hello Saqib",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "What are you going to do?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller.textEditingController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Add To-Do',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.addTodo();
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 26,
                            ),
                          )),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Your To-Do List:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      if (controller.loadingStatus.value ==
                          LoadingStatus.loading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 60 * 2),
                            child: CircularProgressIndicator(
                              color: Color(0xFF6d63ff),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.todos.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(controller.todos[index].todo,
                                  style: TextStyle(
                                      decoration: controller.todos[index].isDone
                                          ? TextDecoration.lineThrough
                                          : null)),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: controller.todos[index].isDone,
                              onChanged: (value) {
                                Database().updateTodo(
                                    id: controller.todos[index].id,
                                    isDone: value!);
                              },
                            ),
                            trailing: GestureDetector(
                                onTap: () async {
                                  await Database().deleteTodo(
                                      id: controller.todos[index].id);
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Deleted To-Do ...")));
                                },
                                child: const Icon(Icons.delete)),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 30;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
