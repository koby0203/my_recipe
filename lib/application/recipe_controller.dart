import 'dart:io';
import 'package:intl/intl.dart';
import 'package:my_recipe/data_source/firebase.dart';
import 'package:my_recipe/domain/recipe.dart';

class RecipeController {
  late Recipe _recipe;

  RecipeController({
    required String title,
    required String description,
    required String ingredients,
    required String procedure,
  }) {
    final imageName =
        "${title}_${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}.png";
    _recipe = Recipe(
      imageName,
      title,
      description,
      ingredients,
      procedure,
    );
  }

  Future<void> addRecipe() async {
    if (_recipe.title == "") {
      throw NoneTitleException("タイトルを入力してください");
    }
    final data = _recipe.toMap();
    final docName =
        "${_recipe.title}_${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}";
    FirestoreService().add(docName, data);
  }

  Future<void> uploadImage(File file) async {
    try {
      String uploadName = _recipe.imageName;
      CloudStorageService().uploadImage(file, uploadName);
    } catch (e) {
      throw Exception();
    }
  }
}

class NoneTitleException implements Exception {
  final String message;

  NoneTitleException(this.message);

  @override
  String toString() {
    return message;
  }
}
