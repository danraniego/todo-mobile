import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/task.dart';

class UpdateTask extends StatefulWidget {

  final Task task;

  const UpdateTask({
    required this.task,
    Key? key}) : super(key: key);

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {

  var formKey = GlobalKey<FormState>();
  late TextEditingController nameController = TextEditingController(text: widget.task.name);
  late TextEditingController detailsController = TextEditingController(text: widget.task.details);
  String date = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update Task"),
        ),

        body: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Task Title",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      return value == null || value.isEmpty
                          ? "Enter Task Title" : null;
                    },
                  ),
                ),
                const Divider(thickness: 1),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: detailsController,
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: "Task Details",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add_task_sharp),
                          onPressed: () {
                            if(formKey.currentState!.validate()){
                              var newTask = Task(
                                name: nameController.text,
                                details: detailsController.text
                              );

                              Navigator.pop(context, newTask);
                            }
                          },
                        )
                    ),
                    validator: (value) {
                      return value == null || value.isEmpty
                          ? "Enter Task Details" : null;
                    },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
