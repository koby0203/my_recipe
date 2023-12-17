class Recipe {
  late Category    category;
  late String      imageName;
  late DishName    dishName;
  late Ingredients ingredients;
  late Procedure   procedure;
}

// 種別
enum Category{
  meatDish('肉料理'),
  fishDish('魚料理'),
  ;
  const Category(this.displayName);
  final String displayName;
}

// タイトル
class DishName {
  static const int min = 1;
  static const int max = 20;

  String value;

  factory DishName(String str) {
    if(str.length < min) {
      throw DishNameException("タイトルは1文字以上必要です");
    }
    if(str.length > max) {
      throw DishNameException("タイトルは20文字以下にしてください");
    }
    return DishName._internal(str);
  }
  DishName._internal(this.value);
}

class DishNameException implements Exception {
  String message;
  DishNameException(this.message);
}

// 食材
class Ingredients {
  String value;
  Ingredients(this.value);
}

// 手順
class Procedure {
  String value;
  Procedure(this.value);
}