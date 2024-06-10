import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'BookScreen.dart';
import 'app_helper.dart';
import 'book.dart';
import 'book_widget.dart';
import 'favorite_books.dart';
import 'favorites.dart';

class BookType extends StatefulWidget {
  final String type;
  const BookType({super.key, required this.type});

  @override
  State<BookType> createState() => _BookTypeState();
}

class _BookTypeState extends State<BookType> {
  Future<List<Book>> getBooksByType() async {
    final token = await AppHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse("${AppHelper.baseUrl}/books/getByType/${widget.type}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> bookData = json.decode(response.body);
      return bookData.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books by type');
    }
  }

  bool isFavorite=false;
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteBooksProvider>(
      builder: (context, favoriteBooksProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Books",
              style: TextStyle(fontSize: 25, color: Colors.purple),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookUploadPage()),
                  );
                },
                icon: Icon(Icons.create_new_folder_sharp),
              ),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoritesList()),
                      );
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
          body: FutureBuilder<List<Book>>(
            future: getBooksByType(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final books = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.type,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.0,
                          mainAxisSpacing: 15.0,
                        ),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return BookWidget(book: book);
                        },
                      ),
                    ),
                  ],
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
        );
      },
    );
  }
}