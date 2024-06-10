import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isdfinal/app_helper.dart';
import 'package:http/http.dart' as http;
import 'package:isdfinal/book_type.dart';
import 'package:isdfinal/user.dart';
import 'package:provider/provider.dart';

import 'BookScreen.dart';
import 'book.dart';
import 'book_widget.dart';
import 'favorite_books.dart';
import 'favorites.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFavorite=false;
  getUsers()async{
    final token = await AppHelper.getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.get(
      Uri.parse('${AppHelper.baseUrl}/users/getAll'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }
  getTopBooks() async {
    final token = await AppHelper.getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.get(
      Uri.parse('${AppHelper.baseUrl}/books/getTopRated'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },

    );

    if (response.statusCode == 200) {

      List<dynamic> data = json.decode(response.body);
      return data.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load top-rated books');
    }
  }
  getBestSellers() async {
    final token = await AppHelper.getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.get(
      Uri.parse('${AppHelper.baseUrl}/books/getBestSellers'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load best sellers');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteBooksProvider>(
        builder: (context, favoriteBooksProvider, child)
        {
          return Scaffold(
            appBar:AppBar(
              title: const Text(
                  "Books", style: TextStyle(fontSize: 25, color: Colors.purple)),
              centerTitle: true,
              //backgroundColor: Colors.white,

              actions: [
                /*IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => BookUploadPage()),);
                    },
                    icon: Icon(Icons.create_new_folder_sharp)
                ),*/
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red,),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => FavoritesList()),);
                      },
                    ),
                    if (favoriteBooksProvider.count > 0)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${favoriteBooksProvider.count}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: FutureBuilder<List<dynamic>>(
                future: Future.wait([getTopBooks(), getBestSellers(), getUsers()]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Book> topBooks = snapshot.data![0] as List<Book>;
                    List<Book> bestSellers = snapshot.data![1] as List<Book>;
                    List<User> users=snapshot.data![2];
                    return ListView(
                        children: [

                                Column(
                                  children: [
                                    SizedBox(height: 15,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => BookType(type: "Love")),);
                                          },
                                          child: Container(
                                            height: 50.0,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                              color: Colors.purple.shade300,
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: const Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                /*Icon(
                                                  Icons.book,
                                                  color: Colors.white,
                                                  size: 16.0,
                                                ),*/
                                                SizedBox(height: 4.0),
                                                Text(
                                                  'Love',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => BookType(type: "Sad")),);
                                          },
                                          child: Container(
                                            height: 50.0,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                              color: Colors.purple.shade300,
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: const Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                /*Icon(
                                                  Icons.book,
                                                  color: Colors.white,
                                                  size: 16.0,
                                                ),*/
                                                SizedBox(height: 4.0),
                                                Text(
                                                  'Sad',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => BookType(type: "Arts")),);
                                          },
                                          child: Container(
                                            height: 50.0,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                              color: Colors.purple.shade300,
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: const Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                               /* Icon(
                                                  Icons.book,
                                                  color: Colors.white,
                                                  size: 16.0,
                                                ),*/
                                                SizedBox(height: 4.0),
                                                Text(
                                                  'Arts',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => BookType(type: "Mystery")),);
                                          },
                                          child: Container(
                                            height: 50.0,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                              color: Colors.purple.shade300,
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: const Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                /*Icon(
                                                  Icons.book,
                                                  color: Colors.white,
                                                  size: 16.0,
                                                ),*/
                                                SizedBox(height: 4.0),
                                                Text(
                                                  'Mystery',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => BookType(type: "Thriller")),);
                                          },
                                          child: Container(
                                            height: 50.0,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                              color: Colors.purple.shade300,
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: const Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                /*Icon(
                                                  Icons.book,
                                                  color: Colors.white,
                                                  size: 16.0,
                                                ),*/
                                                SizedBox(height: 4.0),
                                                Text(
                                                  'Thriller',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => BookType(type: "Fantasy")),);
                                          },
                                          child: Container(
                                            height: 50.0,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                              color: Colors.purple.shade300,
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: const Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                /* Icon(
                                                  Icons.book,
                                                  color: Colors.white,
                                                  size: 16.0,
                                                ),*/
                                                SizedBox(height: 4.0),
                                                Text(
                                                  'Fantasy',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (bestSellers.isNotEmpty)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Best Sellers',
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: bestSellers.length,
                                        itemBuilder: (context, index) {
                                          final book = bestSellers[index];
                                          // Use the book widget you've already created
                                          return BookWidget(book: book);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                if (topBooks.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Top Rated',
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purple,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: topBooks.length,
                                          itemBuilder: (context, index) {
                                            final book = topBooks[index];
                                            // Use the book widget you've already created
                                            return BookWidget(book: book);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Top Writers',
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: users.length,
                                        itemBuilder: (context, index) {
                                          final user = users[index];
                                          // Use the book widget you've already created
                                          return Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundImage: NetworkImage(user.profile),
                                              ),
                                              Text(user.firstname+" "+user.lastname)
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ]
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          );
        }
    );
  }
}
