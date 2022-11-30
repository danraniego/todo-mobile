import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo_app/model/api_response.dart';
import 'package:todo_app/views/home_page.dart';
import 'package:todo_app/views/widgets/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var user_id;


  login(context) async {

    if (!formKey.currentState!.validate()) {
      return;
    }

    Map body = {
      "email": emailController.text,

      "password": passwordController.text
    };
    print(body);

    String email = emailController.text;
    //fetch user_id
    var url = Uri.parse('http://192.168.1.6:8000/api/user/$email');
    print('http://192.168.1.6:8000/api/user/$email');
    var fetchResponse = await http.get(url);
    
    if (fetchResponse.statusCode == 200) {
      var jsonResponse = jsonDecode(fetchResponse.body);
      user_id = (jsonResponse[0]['id']);
    }



    var apiUrl = "${dotenv.env['API_URL']}/login";

    ProgressDialog.spin(context, "Authenticating...");
    await http.post(
                Uri.parse(apiUrl),
                body: json.encode(body),
                headers: {
                  "Content-type": "application/json"
                }
        ).then((http.Response response) {

      Map responseBody = json.decode(response.body);
      ApiResponse apiResponse = ApiResponse(
          success: responseBody["success"],
          message: responseBody["message"],
          data: responseBody["data"] ?? new Map()
      );


      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(apiResponse.message ?? "")
            )
        );
        return;
      }

      setDetails(apiResponse);


    }, onError: (e) {
      print(e);
    });
    ProgressDialog.stop(context);
  }

  setDetails(ApiResponse apiResponse) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", apiResponse.data!['token']);
    prefs.setString("user", json.encode(apiResponse.data!['user']));

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user_id : user_id)),
            (route) => false
    );

    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Ex. dan@email.com",
                labelText: "Email Address"
              ),
              validator: (value ) {
                return value == '' ? 'Please enter email' : null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: "Password",
                  labelText: "Password"
              ),
              validator: (value ) {
                return value == '' ? 'Please enter password' : null;
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  login(context);
                },
                child: const Text("Login")
            )
          ],
        ),
      ),
    );
  }
}
