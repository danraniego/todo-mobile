import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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
    print("Working ${widget.user_id}");
    userID = (widget.user_id).toString();

    print(userID.runtimeType);

    tasks_data = await fetchData('http://192.168.1.6:8000/api/tasks/$userID');

    setState(() {
      tasks = tasks_data;
    });
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

  deleteTask(value){
    setState(() {
      tasks.remove(value);
    });
  }

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
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index){
          final task = tasks[index];

          return Slidable(
            key: UniqueKey(),
            endActionPane: const ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  icon: Icons.delete,
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    onPressed: null//deleteTask(),
                    ),
                SlidableAction(
                  icon: Icons.share,
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    onPressed: null)
              ],
            ),
              child: Card(
                child: ListTile(
                    title: Text(task['name'])
                ),
              ));
        },
      )
    );
  }

}
