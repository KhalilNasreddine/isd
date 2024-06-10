/*
import 'package:flutter/material.dart';
import 'package:isdfinal/app_helper.dart';
import 'package:isdfinal/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'book.dart';
class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Future<List<Book>> getBooksByAuthor() async {
    final token = await AppHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.get(
        Uri.parse('${AppHelper.baseUrl}/books/getByAuthor/${AppHelper.getId()}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load books by author');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${AppHelper.getFirstName()} ${AppHelper.getLastName()}"),
      ),
      body: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage("${AppHelper.getProfile()}"),
                  radius: 60,
                ),
                SizedBox(width: 10,),
                Column(
                  children: [
                    Text("${AppHelper.getFirstName()}"),
                    Text("${AppHelper.getLastName()}")
                  ],
                ),
              ],
            ),

          ],
        ),
      );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:isdfinal/app_helper.dart';
import 'package:isdfinal/book_widget.dart';
import 'package:isdfinal/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'book.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  Future<List<Book>> getBooksByAuthor() async {
    final token = await AppHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }
    final id=await AppHelper.getId();
    final response = await http.get(
      Uri.parse('${AppHelper.baseUrl}/books/getByAuthor/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load books by author');
    }
  }

  String? profile;
  String? firstname;
  String? lastname;
  void setVariables()async {
    profile=await AppHelper.getProfile();
    firstname=await AppHelper.getFirstName();
    lastname=await AppHelper.getLastName();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    //setVariables();
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Hello $firstname $lastname", style: TextStyle(color: Colors.purpleAccent, fontSize: 25)),
        ),
        body: FutureBuilder<List<Book>>(
            future: getBooksByAuthor(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final books = snapshot.data!;
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage("$profile"),
                              radius: 60,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$firstname", style: TextStyle(fontSize: 18),),
                                Text("$lastname", style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("My Books", style: TextStyle(fontSize: 20, color: Colors.purpleAccent),),
                      const SizedBox(height: 5,),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            final book = books[index];
                            return BookWidget(book: book, fav: false,);
                          },
                        ),
                      ),
                    ]
                );
              }
            })
    );
  }
}