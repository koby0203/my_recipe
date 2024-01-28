import 'package:flutter/material.dart';
import 'package:my_recipe/data_source/firebase.dart';

class DetailPage extends StatefulWidget {
  final String docName;
  final String title;
  final String imageName;
  final String imageURL;
  final String tags;
  final String ingredients;
  final String procedure;
  bool isFavorite;

  DetailPage({
    Key? key,
    required this.docName,
    required this.title,
    required this.imageName,
    required this.imageURL,
    required this.tags,
    required this.ingredients,
    required this.procedure,
    required this.isFavorite,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('詳細ページ'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(widget.imageURL,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Text('No Image')),
                      fit: BoxFit.cover),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    TitleWidget(title: widget.title),
                    // お気に入り追加ボタン
                    IconButton(
                      icon: widget.isFavorite
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_border),
                      onPressed: () {
                        setState(() {
                          if (widget.isFavorite) {
                            // お気に入りから削除
                            widget.isFavorite = false;
                            FirestoreService().deleteFavorite(widget.docName);
                          } else {
                            // お気に入りに追加
                            widget.isFavorite = true;
                            FirestoreService().addFavorite(widget.docName);
                          }
                        });
                      },
                    ),
                  ],
                ),
                ContentWidget(title: "説明：", content: widget.tags),
                ContentWidget(title: "材料：", content: widget.ingredients),
                ContentWidget(title: "手順：", content: widget.procedure),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48.0),
                    child: ElevatedButton(
                      onPressed: () => _showDeleteConfirmationDialog(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: const Text('削除'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // ユーザーがダイアログの外をタップして閉じるのを防ぐ
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('本当に削除しますか？'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('いいえ'),
              onPressed: () {
                // ダイアログを閉じる
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('はい'),
              onPressed: () {
                // 処理を実行
                _delete(widget.docName, widget.imageName);
                // ダイアログを閉じる
                Navigator.of(context).pop();
                // 削除後はホーム画面に戻る
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _delete(String docName, String imageName) {
    FirestoreService().delete(docName);
    CloudStorageService().deleteImage(imageName);
  }
}

class ContentWidget extends StatelessWidget {
  const ContentWidget({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0), // テキストから外枠までの間隔
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // 外枠の色
                  width: 0.5, // 外枠の太さ
                ),
                borderRadius:
                    const BorderRadius.all(Radius.circular(8.0)), // 角丸
              ),
              child: Text(content)),
        ],
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
