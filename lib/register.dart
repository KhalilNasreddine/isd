import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:isdfinal/app_helper.dart';
import 'login.dart';
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController firstName=TextEditingController();
  TextEditingController lastName=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  File? profileFile;
  String? profileImage;
  Future<void> pickCoverImageFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      profileFile = File(result.files.single.path!);


      final storageRef = FirebaseStorage.instance.ref('profile_picture/${firstName.text+" "+lastName.text}.jpg');
      await storageRef.putFile(profileFile!);
      profileImage = await storageRef.getDownloadURL();
      print("url for image is $profileImage");

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title:const Text("Sign Up Page", style:TextStyle(fontSize: 25, color:Colors.purple)),
          centerTitle: true,
        ),
        body: Container(
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
                    // // const Center(
                    // //   child: CircleAvatar(
                    // //     radius: 100,
                    // //     backgroundImage: AssetImage('assets/images/logo.png'),
                    // //   ),
                    // // ),
                    const SizedBox(height: 30),
                    Form(
                      key: _formkey,
                      child:Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Sign Up",
                              style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Sign Up to continue using the app",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 20),
                            const Text("First Name",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            const SizedBox(height: 10,),
                            TextFormField(
                              controller: firstName,
                              decoration: InputDecoration(
                                hintText: "Enter first name",
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
                                  return 'Please enter first name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text("Last Name",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            const SizedBox(height: 10,),
                            TextFormField(
                              controller: lastName,
                              decoration: InputDecoration(
                                hintText: "Enter last name",
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
                                  return 'Please enter last name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Email",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(

                              controller: email,
                              decoration: InputDecoration(
                                hintText: "Enter an email",
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
                              obscureText: true,
                              controller: password,
                              decoration: InputDecoration(
                                hintText: "Enter a password",
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
                                          onPressed: () async{
                                            if(_formkey.currentState!.validate()) {
                                              registerUser(context, firstName.text, lastName.text, email.text, password.text, profileImage!);
                                            }
                                          },
                                          child: const Text("Sign Up"),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: pickCoverImageFile,
                                        child: Text('Pick Profile Image'),
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
                                  const Text("Already have an account? "),
                                  InkWell(
                                    onTap:(){Navigator.pushReplacement(context,MaterialPageRoute(
                                        builder: (context) => const LogIn()),);},
                                    child: const Text.rich(
                                      TextSpan(
                                        text: "Log In",
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
                    )
                  ],
                ),
              ],
            )
        )
    );
  }
}
void registerUser(BuildContext context, String fname, String lname, String em, String pass, String profile) async {
  String firstName = fname.trim();
  String lastName = lname.trim();
  String email = em.trim();
  String password = pass;

  // Perform validation
  if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Registration failed. Please fill in all fields.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }

  // Prepare the request body
  Map<String, String> requestBody = {
    "firstname": firstName,
    "lastname": lastName,
    "email": email,
    "password": password,
    "profileimage": profile
  };

  // Send the request
  Uri url = Uri.parse("${AppHelper.baseUrl}/auth/register");
  try {
    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"}, // Set the appropriate header
      body: json.encode(requestBody), // Encode the body as JSON
    );

    if (response.statusCode == 202) {
      // Registration successful, navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()),
      );
    } else {
      // Registration failed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Registration failed. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } catch (error) {
    // Handle network or other errors
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}