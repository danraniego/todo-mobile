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

  login(context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    Map body = {
      "email": emailController.text,
      "password": passwordController.text
    };

    print(body);

    var apiUrl = "${dotenv.env['API_URL']}/login";

    ProgressDialog.spin(context, "Authenticating...");
    await http.post(Uri.parse(apiUrl), body: json.encode(body), headers: {
      "Content-type": "application/json"
    }).then((http.Response response) {
      Map responseBody = json.decode(response.body);
      ApiResponse apiResponse = ApiResponse(
          success: responseBody["success"],
          message: responseBody["message"],
          data: responseBody["data"] ?? new Map());

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(apiResponse.message ?? "")));
        return;
      }

      setDetails(apiResponse);
    }, onError: (e) {
      print(e);
    });
    ProgressDialog.stop(context);
  }

  setDetails(ApiResponse apiResponse) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", apiResponse.data!['token']);
    prefs.setString("user", json.encode(apiResponse.data!['user']));

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => HomePage()), (route) => false);

    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: SingleChildScrollView(
            child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SafeArea(
                  child:
                  Column(
                      children: [
                        const Icon(Icons.phone_android,
                            size: 100),
                        const SizedBox(height: 50),
                        const Text(
                          "Look who's back!",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "This is a custom Log-in Using API-fetching",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25, top: 0),
                          child: Container(
                              height: 75,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      hintText: "Ex. dan@email.com",
                                      labelText: "Email Address"),
                                  validator: (value) {
                                    return value == '' ? 'Please enter email' : null;
                                  },
                                ),
                              )),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25, top: 0),
                          child: Container(
                              height: 75,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  controller: passwordController,
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      hintText: "Password", labelText: "Password"),
                                  validator: (value) {
                                    return value == '' ? 'Please enter password' : null;
                                  },
                                ),
                              )),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    login(context);
                                  },
                                  child: const Text("Sign In")),
                            )
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Not a member?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("  Register now",
                                style: TextStyle(
                                    color: Colors.blue, fontWeight: FontWeight.bold))
                          ],
                        )
                      ]
                  ),
                )
            ),
          ),
        )
    );
  }
}
