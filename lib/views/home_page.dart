import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:todo_app/model/task.dart';
import 'package:todo_app/views/task_details.dart';

class HomePage extends StatefulWidget {

  final user_id;

  const HomePage({required this.user_id, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late List tasks = [];
  late var tasks_data;

  var userID;

  callData() async {
    userID = (widget.user_id).toString();

    tasks_data = await fetchData('http://192.168.1.6:8000/api/tasks/$userID');

    for(int i = 0; i < tasks_data.length; i++) {
      setState(() {
        tasks.add(Task.fromJson(tasks_data[i]));
      });

    }
  }

  Future <dynamic> fetchData(String link) async {

    var url = Uri.parse(link);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      //Json to Object


      return jsonResponse;
    }
    else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  void removeData(int index){
    setState(() {
      tasks.removeAt(index);
    });
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
                          onPressed: (context) => removeData(index)
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
        )
    );
  }

}


