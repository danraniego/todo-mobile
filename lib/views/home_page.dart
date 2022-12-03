import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:todo_app/model/task.dart';
import 'package:todo_app/views/add_task.dart';
import 'package:todo_app/views/task_details.dart';

class HomePage extends StatefulWidget {

  final int userID;

  const HomePage({required this.userID, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late List tasks = [];
  late List tasksData;

  callData() async {


    tasksData = await fetchData('http://192.168.1.6:8000/api/${widget.userID}/tasks');

    for(int i = 0; i < tasksData.length; i++) {

      setState(() {
        //Json to Object
        tasks.add(Task.fromJson(tasksData[i]));
      });
    }
  }

  Future <dynamic> fetchData(String link) async {

    var url = Uri.parse(link);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      return jsonResponse;
    }
    else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }


  void removeData(var task) async{

    var url = Uri.parse('http://192.168.1.6:8000/api/tasks/${task.id}');

    var response = await http.delete(url);

    if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Task Deleted"),
            backgroundColor: Colors.red,
            padding: const EdgeInsets.all(15),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
        )
        );

        setState(() {
          tasks.remove(task);
        });
    }
    else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }

  }


  void addData(var newTask) async {

    if(newTask == null){
      return;
    }

    var url = Uri.parse('http://192.168.1.6:8000/api/tasks?name='
        '${newTask.name}&details=${newTask.details}&user_id=${widget.userID}');

    var response = await http.post(url);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Task Added"),
        backgroundColor: Colors.lightBlueAccent,
        padding: const EdgeInsets.all(15),
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      )
      );
      setState(() {
        tasks.add(newTask);
      });
    }
    else {
      throw Exception(
          "Request failed with a status code: ${response.statusCode} ");
    }
  }


  @override
  void initState(){
    callData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Tasks"),
        ),
        body:  SlidableAutoCloseBehavior(
          closeWhenOpened: true,
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index){
              final task = tasks[index];

              return Slidable(
                  key: UniqueKey(),
                  endActionPane: ActionPane(
                    extentRatio: 1 / 1.5,

                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          label: "Delete",
                          onPressed: (context) => removeData(task)
                      ),
                      SlidableAction(
                          icon: Icons.edit_note,
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          label: "Edit",
                          onPressed: null),
                      SlidableAction(
                          icon: Icons.share,
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          label: "Share",
                          onPressed: null),
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.task_sharp),
                      title: Text(task.name),
                      subtitle: Text(task.createdAt),
                      onTap: () {
                        Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetails(task: task)
                        ));
                      },
                    ),
                  ));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => TaskForm(addTask: addData, userID: widget.userID, listLength: tasks.length)
            ));
          },
          child: Icon(Icons.add_task),
        ),
    );
  }

}


