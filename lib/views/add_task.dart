import 'package:flutter/material.dart';
import 'package:todo_app/model/task.dart';
import 'package:intl/intl.dart';

class TaskForm extends StatefulWidget {

  final Function addTask;
  final int userID;
  final int listLength;

  const TaskForm({
    required this.addTask,
    required this.userID,
    required this.listLength,
    Key? key}) : super(key: key);

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {

  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  String date = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
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
                                id: widget.listLength + 1,
                                name: nameController.text,
                                details: detailsController.text,
                                createdAt: date,
                                updatedAt: date
                              );
                              widget.addTask(newTask);
                              Navigator.pop(context);
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
