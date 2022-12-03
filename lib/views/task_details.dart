import 'package:flutter/material.dart';
import 'package:todo_app/model/task.dart';
import 'package:intl/intl.dart';

class TaskDetails extends StatelessWidget {

  final Task task;

  TaskDetails({required this.task, super.key});

  late DateTime taskDate = DateTime.parse(task.updatedAt!);
  
  late String date = DateFormat('h:mm a MMMM d, yyyy').format(taskDate);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text(date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.4)
                    )),
                  ],
                )
            ),
            Padding(
              padding: const EdgeInsets.only(left:10, right: 10, top: 10, bottom: 2),
                child: Row(
                  children: [
                    Text(task.name!,
                    style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                )),
                  ],
                )
            ),
            const Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(task.details!,
                      style: const TextStyle(
                        height: 1.5,
                      )),
                  )
                ],
              )
            ),
          ],
        ),
      )

    );
  }
}