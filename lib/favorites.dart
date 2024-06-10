import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorite_books.dart';
import 'book.dart';

class FavoritesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<FavoriteBooksProvider>(
          builder: (context, favoriteBooksProvider, child) {
            return ListView.builder(
              itemCount: favoriteBooksProvider.favorites.length,
              itemBuilder: (context, index) {
                final book = favoriteBooksProvider.favorites[index];
                return ListTile(
                  leading: Image.network(book.coverImageUrl),
                  title: Text(book.title),
                  subtitle: Text("${book.price}"),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      favoriteBooksProvider.removeBook(book);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}