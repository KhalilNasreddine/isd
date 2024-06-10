import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:isdfinal/BookScreen.dart';

class FormProvider extends ChangeNotifier {

  static String title = '';
  static String type='';
  static String description = '';
  static double price = 0.0;
  // File? _coverImageFile;
  // String? _coverImageUrl;



  /*String get title => _title;
  String get type => _type;
  String get description => _description;
  double get price => _price;*/
  // File? get coverImageFile => _coverImageFile;
  // String? get coverImageUrl => _coverImageUrl;



  /*Future<void> pickCoverImageFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      _coverImageFile = File(result.files.single.path!);
      notifyListeners();

      final storageRef = FirebaseStorage.instance.ref('book_covers/${title}.jpg');
      await storageRef.putFile(_coverImageFile!);
      _coverImageUrl = await storageRef.getDownloadURL();
      print("url for image is $_coverImageUrl");
      notifyListeners();
    }
  }*/

  void changeTitle(String value) {
    title = value;
    notifyListeners();
  }

  void changeType(String value) {
    type = value;
    notifyListeners();
  }

  void changeDescription(String value) {
    description = value;
    notifyListeners();
  }
  void changePrice(double value){
    price=value;
    notifyListeners();
  }
  String getType(){
    return type;
  }
}