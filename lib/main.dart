import 'dart:io';
import 'package:isdfinal/home.dart';
import 'package:isdfinal/home_screen.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'favorite_books.dart';
import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
        create: (_) => FavoriteBooksProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Home(),
      )
    );
  }
}
/*class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? file;
  String? url;
  getImage()async{
    final ImagePicker picker=ImagePicker();
    //final XFile? image=await picker.pickImage(source: ImageSource.gallery);
    final XFile? photo= await picker.pickImage(source: ImageSource.camera);
    if(photo!=null) {
      file=File(photo!.path);
      var name=basename(photo.path);
      var refStorage = FirebaseStorage.instance.ref(name);
      await refStorage.putFile(file!);
      url=await refStorage.getDownloadURL();
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 400,),
            MaterialButton(
              onPressed: ()async{
                await getImage();
              },
              child: Text("Capture an image"),
            ),
            if(url!=null)
              Image.network(
                url!,
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              )
          ],
        ),
      ),
    );
  }
}*/

/*
import 'dart:convert';
import 'package:isdfinal/BookScreen.dart';
import 'package:isdfinal/favorite_books.dart';
import 'package:isdfinal/favorites.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
    "Fiction",
    "Mystery",
    "Thriller"
        "Fantasy",
    "Science",
    "Arts",
    "Poetry",
    "Adventure",
    "Drama",
    "Philosophy",
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
    final appHelper = AppHelper();
    final token = await appHelper.getToken();

    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.get(
      Uri.parse("http://172.17.162.133:8080/api/v1/books/getAll"),
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

    return Scaffold(
        appBar: AppBar(
          title: const Text("Books", style: TextStyle(fontSize: 25, color: Colors.purple)),
          centerTitle: true,

          actions: [
            IconButton(
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(
                      builder: (context) => BookUploadPage()),);
                },
                icon: Icon(Icons.create_new_folder_sharp)
            ),
            IconButton(
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(
                      builder: (context) => FavoritesList()),);
                },
                icon: Icon(Icons.favorite))
          ],
        ),
        body: Consumer<FavoriteBooksProvider>(
            builder: (context, favoriteBooksProvider, child) {

              return FutureBuilder<List<Book>>(
                future: fetchAllBooks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      color: Colors.purple[50],
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
                              CarouselSlider(
                                options: CarouselOptions(
                                  autoPlay: false,
                                  aspectRatio: 2.0,
                                  enlargeCenterPage: true,
                                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                                  viewportFraction: 0.6,
                                ),
                                items: booksOfType.map((book) => Container(
                                  width: 250,
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
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                //const SizedBox(height: 0.0),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Price: ",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14.0,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${book.price.toStringAsFixed(2)}",
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14.0,
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
                                )).toList(),
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
              );
            }
        )
    );
  }
}*/
/*

Scaffold(
      appBar: AppBar(
        title: const Text("Books", style: TextStyle(fontSize: 25, color: Colors.purple)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Book>>(
        future: fetchAllBooks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                      ),
                      items: booksOfType
                          .map((book) => ListTile(
                        leading: Image.network(book.coverImagePath),
                        title: Text(book.title),
                        subtitle: Text('by author'),
                        trailing: Text('\$${book.price}'),
                        onTap: () {
                          // Navigate to a book detail screen or open the PDF
                        },
                      ))
                          .toList(),
                    ),
                  ],
                )
                    : const SizedBox.shrink();
              },
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
 */
