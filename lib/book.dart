/*
class Book {
  final int id;
  final String description;
  final String type;
  final String title;
  final double price;
  final String coverImageUrl;
  //final String pdfUrl;
  //final int authorId;

  Book({
    required this.id,
    required this.description,
    required this.type,
    required this.title,
    required this.price,
    required this.coverImageUrl,
    //required this.pdfUrl,
    //required this.authorId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      description: json['description'],
      type: json['type'],
      title: json['title'],
      price: json['price'],
      coverImageUrl: json['coverImageUrl'],
      //pdfUrl: json['pdfPath'],
      //authorId: json['authorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'type': type,
      'title': title,
      'price': price,
      'coverImageUrl': coverImageUrl,
      //'pdfFile': pdfUrl,
      //'authorId': authorId,
    };
  }
}*/
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

class Book {
  final int id;
  final String description;
  final String type;
  final String title;
  final double price;
  final String coverImageUrl;
  final int soldCopies;
  final double rating;
  final DateTime createdDate;
  final int authorId;
  final String authorName;

  Book({
    required this.id,
    required this.description,
    required this.type,
    required this.title,
    required this.price,
    required this.coverImageUrl,
    required this.soldCopies,
    required this.rating,
    required this.createdDate,
    required this.authorId,
    required this.authorName
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      description: json['description'],
      type: json['type'],
      title: json['title'],
      price: json['price'],
      coverImageUrl: json['coverImageUrl'],
      soldCopies: json['soldCopies'],
      rating: json['rating'],
      createdDate: DateTime.parse(json['createdDate']),
      authorName: json['authorDTO']['fullName'],
      authorId: json['authorDTO']['id'], // Access the author's ID from the authorDTO object
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'type': type,
      'title': title,
      'price': price,
      'coverImageUrl': coverImageUrl,
      'soldCopies': soldCopies,
      'rating': rating,
      'createdDate': createdDate,
      'authorId': authorId,

    };
  }
}

class BookController {
  static const String baseUrl = 'http://your-api-url-here/api/books';

  Future<List<Book>> getAllBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/getAll'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<Book> getBookById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/getById/$id'));

    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load book');
    }
  }

  Future<Book> createBook(Book book, int authorId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create?authorId=$authorId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode == 201) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create book');
    }
  }

  Future<Book> updateBook(int id, Book book) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update book');
    }
  }

  Future<void> deleteBook(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete book');
    }
  }

  Future<Book> incrementSoldCopies(int id) async {
    final response = await http.post(Uri.parse('$baseUrl/increment/$id'));

    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to increment sold copies');
    }
  }

  Future<List<Book>> getBooksByAuthor(int authorId) async {
    final response = await http.get(Uri.parse('$baseUrl/getByAuthor/$authorId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load books by author');
    }
  }

  Future<List<Book>> getTopRatedBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/getTopRated'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load top-rated books');
    }
  }

  Future<List<Book>> getBestSellers() async {
    final response = await http.get(Uri.parse('$baseUrl/getBestSellers'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load best sellers');
    }
  }

  Future<List<Book>> getNewestBooks(int page, int size) async {
    final response = await http.get(Uri.parse('$baseUrl/getNewest?page=$page&size=$size'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['content'];
      return data.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load newest books');
    }
  }
}