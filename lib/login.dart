import 'dart:convert';
import 'package:isdfinal/home_page.dart';
import 'package:isdfinal/home_screen.dart';

import 'BookScreen.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'app_helper.dart';
import 'books.dart';
import 'register.dart';
import 'package:flutter/material.dart';
class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController email=TextEditingController();
  TextEditingController password= TextEditingController();
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  //final GlobalKey<FormState> _formKey1=GlobalKey<FormState>();
  bool isLoading =false;

  Future<void> login(String email, String password) async {
    // Uri url = Uri.parse("http://192.168.1.4:8080/api/v1/auth/authenticate");
    Uri url = Uri.parse("${AppHelper.baseUrl}/auth/authenticate");
    final body = jsonEncode({
      "email": email,
      "password": password,
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final String token = jsonResponse["token"];
      final String firstName=jsonResponse["firstname"];
      final String lastName=jsonResponse["lastname"];
      final String email=jsonResponse["email"];
      final int id=jsonResponse["id"];
      final String profile=jsonResponse["profileimage"];
      await AppHelper.setLastName(lastName);
      await AppHelper.setFirstName(firstName);
      await AppHelper.setEmail(email);
      await AppHelper.setFirstName(firstName);
      await AppHelper.setId(id);
      await AppHelper.storeToken(token);
      await AppHelper.setProfile(profile);
      print(AppHelper.getId());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  HomeScreen()),
      );
    } else {
      throw Exception('Failed to login and retrieve token');
    }
  }


  // Future<void> login() async {
  //   final url = Uri.parse('https://your-api-url.com/login'); // Replace with your API endpoint
  //
  //   final body = jsonEncode({
  //     'email': email.text,
  //     'password': password.text,
  //   });
  //
  //   final headers = {'Content-Type': 'application/json'};
  //
  //   final response = await http.post(url, headers: headers, body: body);
  //
  //   if (response.statusCode == 200) {
  //     final jsonResponse = jsonDecode(response.body);
  //     final token = jsonResponse['token'];
  //     // Do something with the token
  //     Navigator.pushReplacementNamed(context, '/home');
  //   } else {
  //     final errorResponse = jsonDecode(response.body);
  //     final errorMessage = errorResponse['message'];
  //
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title:const Text("Log In Page", style:TextStyle(fontSize: 25, color:Colors.purple)),
          centerTitle: true,
        ),
        body:  isLoading?const Center(
          child: CircularProgressIndicator(),)
            :Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/BookBack.png'),
                  fit: BoxFit.cover,
                )
            ),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 20),
                    // const Center(
                    //   child: CircleAvatar(
                    //     radius: 100,
                    //     backgroundImage: AssetImage("assets/images/logo.png"),
                    //   ),
                    // ),
                    const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child:Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Login",
                              style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Login to continue using the app",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Email",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                hintText: "Enter your email",
                                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                                contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Password",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: password,

                              decoration: InputDecoration(
                                hintText: "Enter your password",
                                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                                contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: ()async {

                              },
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: MaterialButton(
                                          height: 40,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                          color: Colors.purple,
                                          textColor: Colors.white,
                                          onPressed: ()async {
                                            if(_formKey.currentState!.validate()) {
                                              login(email.text, password.text);
                                            }
                                          },
                                          child: const Text("Log in"),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            //Text("Don't have an account", style: TextStyle(fontSize: 15),)
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account? "),
                                  InkWell(
                                    onTap:(){Navigator.pushReplacement(context,MaterialPageRoute(
                                        builder: (context) => const Register()),);},
                                    child: const Text.rich(
                                      TextSpan(
                                        text: "Register",
                                        style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
        )
    );
  }
}

