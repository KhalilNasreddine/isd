import 'dart:convert';
import 'dart:io';
import 'app_helper.dart';
import 'book.dart';
import 'package:http/http.dart' as http;
class BookApi{

   fetchBooksByType(String type) async {
    final token = await AppHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse("http://192.168.1.5:8080/api/v1/books/type/$type"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  fetchAllBooks() async {
    final token = await AppHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.get(
      Uri.parse("http://192.168.1.5:8080/api/v1/books/getAll"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {

      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<Book> fetchBookById(int id) async {
    final token = await AppHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.get(
      Uri.parse("http://192.168.1.5:8080/api/v1/books/getById/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
    },
    );

    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load book');
    }
  }

   Future<Book> createBook({
     required String description,
     required String type,
     required String title,
     required double price,
     required int authorId,
     required File pdfFile,
     required File coverImageFile,
   }) async {
     final token = await AppHelper.getToken();

     if (token == null) {
       throw Exception('No token found');
     }
     var request = http.MultipartRequest(
       'POST',
       Uri.parse("http://192.168.1.5:8080/api/v1/books/create"),
     );
     request.headers['Authorization'] = 'Bearer $token';
     request.fields['description'] = description;
     request.fields['type'] = type;
     request.fields['title'] = title;
     request.fields['price'] = price.toString();
     request.fields['authorId'] = authorId.toString();
     request.files.add(await http.MultipartFile.fromPath('pdfFile', pdfFile.path));
     request.files.add(await http.MultipartFile.fromPath('coverImageFile', coverImageFile.path));

     var response = await request.send();

     if (response.statusCode == 200) {
       var responseBody = await response.stream.bytesToString();
       return Book.fromJson(jsonDecode(responseBody));
     } else {
       throw Exception('Failed to create book');
     }
   }
/*

  Future<Book> createBook(Book book, int authorId) async {
    final appHelper = AppHelper();
    final token = await appHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.post(
      Uri.parse("http://192.168.1.5:8080/api/v1/books/create?authorId=$authorId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(book.toJson()),
    );

    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create book');
    }
  }

*/

  Future<Book> updateBook({
    required int id,
    required String description,
    required String type,
    required String title,
    required double price,
    File? pdfFile,
    File? coverImageFile,
  }) async {
    final token = await AppHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }
    var request = http.MultipartRequest(
      'Put',
      Uri.parse("http://192.168.1.5:8080/api/v1/books/update/$id"),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = description;
    request.fields['type'] = type;
    request.fields['title'] = title;
    request.fields['price'] = price.toString();
    if (pdfFile != null) {
      request.files.add(await http.MultipartFile.fromPath('pdfFile', pdfFile.path));
    }
    if (coverImageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('coverImageFile', coverImageFile.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      return Book.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to update book');
    }
  }
  /*
  Future<Book> updateBook(int id, Book bookDetails) async {
    final appHelper = AppHelper();
    final token = await appHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.put(
      Uri.parse("http://192.168.1.5:8080/api/v1/books/update/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(bookDetails.toJson()),
    );

    if (response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update book');
    }
  }
*/
  Future<void> deleteBook(int id) async {
    final token = await AppHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.delete(
      Uri.parse("http://192.168.1.5:8080/api/v1/books/delete/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete book');
    }
  }
}