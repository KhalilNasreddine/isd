import 'package:flutter/material.dart';
import 'package:isdfinal/favorite_books.dart';
import 'package:provider/provider.dart';

import 'book.dart';
import 'book_details.dart';
class BookWidget extends StatefulWidget {
  final Book book;
  final bool fav;

  const BookWidget({
    super.key,
    required this.book,
    this.fav = true,
  });
  @override
  State<BookWidget> createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget> {

  bool isFavorite=false;
  @override
  Widget build(BuildContext context) {
    Book book=widget.book;
    return Consumer<FavoriteBooksProvider>(
        builder: (context, favoriteBooksProvider, child) {
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
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              // Optional: Add some spacing between cards
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
                        height: double
                            .infinity, // Ensure the image covers the entire card
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
                                if(widget.fav)
                                IconButton(
                                  icon: Icon(
                                    favoriteBooksProvider.checkIfFavorite(book)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  onPressed: () {
                                    if (favoriteBooksProvider.checkIfFavorite(
                                        book)) {
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
        }
    );
  }
}
