import 'package:flutter/material.dart';
import 'package:todo_app/views/login.dart';
import 'package:todo_app/views/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To Do',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(),
      )
  );
}


