import 'dart:convert';
import 'BookScreen.dart';
import 'book_details.dart';
import 'favorite_books.dart';
import 'favorites.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'app_helper.dart';
import 'book.dart';
class Books extends StatefulWidget {
  const Books({super.key});
  @override
  State<Books> createState() => _BooksState();
}
class _BooksState extends State<Books> {
  List<String> types = [
    //"Fiction",
    "Mystery",
    //"Thriller",
    "Fantasy",
    "Science",
    "Arts",
    //"Poetry",
    //"Adventure",
    //"Drama",
    //"Philosophy",
    "Love",
    "Sad"
  ];
  List<Book> books = [];
  //List<Book> favoritedBooks = [];
  @override
  void initState() {
    super.initState();
    updateData();

  }
  updateData()async{
    books=await fetchAllBooks();
    //favoritedBooks = [];
    setState(() {
    });
  }
  Future<List<Book>> fetchAllBooks() async {
    final token = await AppHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.get(
      Uri.parse("${AppHelper.baseUrl}/books/getAll"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {

      List<dynamic> body = json.decode(response.body);
      print(body);
      return body.map((dynamic item) => Book.fromJson(item)).toList();

    } else {
      throw Exception('Failed to load books');
    }
  }
  bool isFavorite=false;

  @override
  Widget build(BuildContext context) {

    return Consumer<FavoriteBooksProvider>(
        builder: (context, favoriteBooksProvider, child) {
       return Scaffold(
        appBar: AppBar(
          title: const Text("Books", style: TextStyle(fontSize: 25, color: Colors.purple)),
          centerTitle: true,
          backgroundColor: Colors.white,

          actions: [
            IconButton(
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(
                      builder: (context) => BookUploadPage()),);
                },
                icon: Icon(Icons.create_new_folder_sharp)
            ),
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red,),
                  onPressed: (){
                    Navigator.push(context,MaterialPageRoute(
                        builder: (context) => FavoritesList()),);
                  },
                ),
                if (favoriteBooksProvider.count > 0)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${favoriteBooksProvider.count}',
                        style: TextStyle(
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
                future: fetchAllBooks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: types.length,
                        itemBuilder: (BuildContext context, int index) {
                          final booksOfType = books.where((book) => book.type == types[index]).toList();
                          return booksOfType.isNotEmpty
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  types[index],
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
                                  itemCount: booksOfType.length,
                                  itemBuilder: (context, index) {
                                    final book = booksOfType[index];
                                    return GestureDetector(
                                      onLongPress: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BookDetailsPage(book: book),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 150,
                                        margin: EdgeInsets.symmetric(horizontal: 4.0), // Optional: Add some spacing between cards
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                          elevation: 5,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(25.0),
                                                child: Image.network(
                                                  book.coverImageUrl,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity, // Ensure the image covers the entire card
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  //height: 100,
                                                  padding: const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.3),
                                                    borderRadius: const BorderRadius.only(
                                                      bottomLeft: Radius.circular(25.0),
                                                      bottomRight: Radius.circular(25.0),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        book.title,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 15.0,

                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                "Price: ",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                "${book.price.toStringAsFixed(2)}",
                                                                style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 12.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              favoriteBooksProvider.checkIfFavorite(book)
                                                                  ? Icons.favorite
                                                                  : Icons.favorite_border,
                                                              color: Colors.white,
                                                              size: 24.0,
                                                            ),
                                                            onPressed: () {
                                                              if (favoriteBooksProvider.checkIfFavorite(book)) {
                                                                favoriteBooksProvider.removeBook(book);
                                                              } else {
                                                                favoriteBooksProvider.addBook(book);
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                            ],
                          )
                              : const SizedBox.shrink();
                        },
                      ),
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
              ),);
            }
    );
  }
}
