import 'package:flutter/material.dart';
import 'package:todo_app/model/task.dart';

class TaskDetails extends StatelessWidget {

  final Task task;

  const TaskDetails({required this.task, super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text(task.updatedAt!,
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
            Divider(thickness: 1),
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