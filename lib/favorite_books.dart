import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'book.dart';

class FavoriteBooksProvider extends ChangeNotifier {
  List<Book> _favorites = [];

  List<Book> get favorites => _favorites;

  Future<void> addBook(Book book) async {
    _favorites.add(book);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> removeBook(Book book) async {
    _favorites.remove(book);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString('favorites');
    if (favoritesJson != null) {
      final favoritesData = jsonDecode(favoritesJson) as List<dynamic>;
      _favorites = favoritesData.map((bookData) => Book.fromJson(bookData)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = jsonEncode(_favorites.map((book) => book.toJson()).toList());
    await prefs.setString('favorites', favoritesJson);
  }
  bool checkIfFavorite(Book book){
    if(favorites.contains(book)) return true;
    return false;
  }

  int get count=>_favorites.length;
}