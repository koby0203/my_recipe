class Recipe {
  String imageName;
  String title;
  String tags;
  String ingredients;
  String procedure;

  Recipe(
      this.imageName, this.title, this.tags, this.ingredients, this.procedure);

  Map<String, String> toMap() {
    return {
      'imageName': imageName,
      'title': title,
      'ingredients': ingredients,
      'procedure': procedure,
    }..addAll(separateTags());
  }

  Map<String, String> separateTags() {
    var tagList = tags.split(' ');
    var tagMap = <String, String>{};
    for (var i = 0; i < tagList.length; i++) {
      tagMap['tag${i + 1}'] = tagList[i];
    }
    return tagMap;
  }
}
