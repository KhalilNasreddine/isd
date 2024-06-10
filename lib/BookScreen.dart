import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:isdfinal/book_type.dart';
import 'package:isdfinal/form_provider.dart';
import 'package:isdfinal/home_page.dart';
import 'package:provider/provider.dart';

import 'app_helper.dart';
import 'book.dart';
import 'books.dart';

class BookUploadPage extends StatefulWidget {
  @override
  _BookUploadPageState createState() => _BookUploadPageState();
}

class _BookUploadPageState extends State<BookUploadPage> {
  List<String> _types = [
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
  List<String> get types=>_types;
  final _formKey = GlobalKey<FormState>();

  File? _coverImageFile;
  String? _coverImageUrl;
  Future<void> pickCoverImageFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      _coverImageFile = File(result.files.single.path!);


      final storageRef = FirebaseStorage.instance.ref('book_covers/${FormProvider.title}.jpg');
      await storageRef.putFile(_coverImageFile!);
      _coverImageUrl = await storageRef.getDownloadURL();
      print("url for image is $_coverImageUrl");

    }
  }

  /*Future<void> _pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf']
    );
    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
      });
      final storageRef = FirebaseStorage.instance.ref('pdf_files/$_title.jpg');
      await storageRef.putFile(_pdfFile!);
      _pdfUrl = await storageRef.getDownloadURL();
      print("url for pdf is $_pdfUrl");
      setState(() {

      });
    }
  }*/


  String? type;
  Future<Book> _createBook() async {
    if(_coverImageUrl!=null) {
      //print("${AppHelper.getId()}   ${AppHelper.getToken()}");
      final token = await AppHelper.getToken();
      final authorId=await AppHelper.getId();
      final url = Uri.parse("${AppHelper.baseUrl}/books/create?authorId=${authorId}");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "description": FormProvider.description,
          "type": type,
          "title": FormProvider.title,
          "price": FormProvider.price,
          "coverImageUrl": _coverImageUrl,
        }),
      );


      if (response.statusCode == 201) {
        final bookData = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Book Created'),
              content: const Text('The book has been created successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        //Navigator.pushReplacement(context, HomePage());
        return Book.fromJson(bookData);
      } else {
        throw Exception('Failed to create the book');
      }
    }else{
      throw Exception('The url is null');
    }



  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create:(_)=>FormProvider(),
        child: Consumer<FormProvider>(
            builder: (context, formProvider, child) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Upload Book'),
                ),
                body: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/drawing.png'),
                        fit: BoxFit.cover,
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Book Title',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              formProvider.changeTitle(value);
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Book Description',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                formProvider.changeDescription(value);
                              });
                            },
                          ),
                          SizedBox(height: 16),

                          DropdownButtonFormField<String>(
                            value: type=types[0],
                            onChanged: (value) {
                              type = value!;

                            },
                            items: types.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Book Type',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Book Price',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a price';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              formProvider.changePrice(double.parse(value));
                            },
                          ),
                          SizedBox(height: 16),

                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*ElevatedButton(
                      onPressed: _pickPdfFile,
                      child: Text('Pick PDF File'),
                    ),*/
                              ElevatedButton(
                                onPressed: pickCoverImageFile,
                                child: Text('Pick Cover Image'),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _createBook,
                            child: Text('Upload Book'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
        )
    );
  }
}


/*Future<void> _uploadBook() async {
    final appHelper = AppHelper();
    final token = await appHelper.getToken();

    if (_formKey.currentState!.validate() *//*&& _pdfFile != null*//* && url != null) {

      final request = http.MultipartRequest('POST',
          Uri.parse("http://192.168.1.7:8080/api/v1/books/create"));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['description'] = _description;
      request.fields['type'] = _type;
      request.fields['title'] = _title;
      request.fields['price'] = _price.toString();
      request.fields['authorId'] = _authorId.toString();
      request.fields['coverImagePath'] = url!;
      //request.files.add(await http.MultipartFile.fromPath('pdfFile', _pdfFile!.path));
      //request.files.add(await http.MultipartFile.fromPath('coverImageFile', _coverImageFile!.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        // Book uploaded successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Book uploaded successfully'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Books()),
        );
      } else {
        // Handle upload error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload book'),
          ),
        );
      }
    }
  }*/