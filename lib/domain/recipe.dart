class Recipe {
  late String      _imageName;
  late DishName    _dishName;
  late Ingredients _ingredients;
  late Procedure   _procedure;

  set setImageName(String name) => _imageName = name;
  String get imageName => _imageName;

  set setTitle(DishName title) => _dishName = title;
  DishName get title => _dishName;

  set setIngredients(Ingredients ingredients) => _ingredients = ingredients;
  Ingredients get ingredients => _ingredients;
    
  set setProcdure(Procedure procedure) => _procedure = procedure;
  Procedure get procedure => _procedure;
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