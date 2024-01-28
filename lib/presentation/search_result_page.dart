import 'package:flutter/material.dart';
import 'package:my_recipe/data_source/firebase.dart';
import 'package:my_recipe/presentation/detail_page.dart';

class SearchResultPage extends StatefulWidget {
  final String word;

  const SearchResultPage({Key? key, required this.word}) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('検索結果'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: StreamBuilder(
          stream: FirestoreService().search(widget.word),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('エラーが発生しました: ${snapshot.error}');
            }

            var documents = snapshot.data!.docs;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var data = documents[index].data() as Map<String, dynamic>;

                // Firestoreから取得したデータ
                String title = data['title'];
                String imageName = data['imageName'];
                String tag1 = data['tag1'] ?? '';
                String tag2 = data['tag2'] ?? '';
                String tag3 = data['tag3'] ?? '';
                String tags = '$tag1 $tag2 $tag3';
                String ingredients = data['ingredients'];
                String procedure = data['procedure'];
                bool isFavorite = data['favorite'] ?? false;

                // ドキュメント名（詳細ページで削除または編集する際に必要）
                String docName = documents[index].id;

                return FutureBuilder(
                  future: CloudStorageService().getImageURL(imageName),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (imageSnapshot.hasError) {
                      return Text('画像の取得中にエラーが発生しました: ${imageSnapshot.error}');
                    }

                    String imageURL = imageSnapshot.data as String;

                    return InkWell(
                      onTap: () {
                        // タイルが押下されたときの処理
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              docName: docName,
                              title: title,
                              imageName: imageName,
                              imageURL: imageURL,
                              tags: tags,
                              ingredients: ingredients,
                              procedure: procedure,
                              isFavorite: isFavorite,
                            ),
                          ),
                        );
                      },
                      child: GridTile(
                        footer: GridTileBar(
                          backgroundColor: Colors.black45,
                          title: Text(title),
                        ),
                        child: Image.network(imageURL,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(child: Text('No Image')),
                            fit: BoxFit.cover),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
