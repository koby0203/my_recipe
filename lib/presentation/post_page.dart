import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_recipe/application/recipe_controller.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _procedureController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _image == null
                    ?
                    // 画像選択されていない場合は、追加ボタンを表示
                    InkWell(
                        onTap: () {
                          _getImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 48.0, bottom: 8.0), // 上下の余白を追加
                          child: Ink(
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey, // タッチ領域の背景色
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(30.0), // アイコンの余白を追加
                              child: Icon(
                                Icons.add_a_photo,
                                size: 30.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    // 画像選択されている場合は画像表示
                    : Image.file(_image!),
                TitleWidget(titleController: _titleController),
                ContentWidget(
                    hintText: 'タグ(3つまで入力可能)\r\n(例)#肉料理 #和食 #時短料理',
                    descriptionController: _descriptionController),
                ContentWidget(
                    hintText: '材料\r\n',
                    descriptionController: _ingredientsController),
                ContentWidget(
                    hintText: '手順\r\n',
                    descriptionController: _procedureController),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48.0),
                    child: ElevatedButton(
                      onPressed: () async => _register(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: const Text('投稿'),
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

  void _register(BuildContext context) async {
    try {
      // Recipe情報の登録
      final rCntrl = RecipeController(
          title: _titleController.text,
          description: _descriptionController.text,
          ingredients: _ingredientsController.text,
          procedure: _procedureController.text);
      await rCntrl.addRecipe();

      // 画像登録
      if (_image != null) {
        await rCntrl.uploadImage(_image!);
      }

      // 登録成功
      // ignore: use_build_context_synchronously
      _showAddResultDialog(context, "Success", "投稿完了しました！");
      clearText();
      setState(() {
        _image = null;
      });
    } on NoneTitleException catch (e) {
      // タイトルが空の場合
      // ignore: use_build_context_synchronously
      _showAddResultDialog(context, "Error", e.toString());
    } catch (e) {
      // 登録失敗
      // ignore: use_build_context_synchronously
      _showAddResultDialog(context, "Error", "投稿失敗しました。やり直して下さい。");
    }
  }

  void _showAddResultDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
              },
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }

  void clearText() {
    _titleController.clear();
    _descriptionController.clear();
    _ingredientsController.clear();
    _procedureController.clear();
  }

  Future<void> _getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }
}

class ContentWidget extends StatelessWidget {
  const ContentWidget({
    super.key,
    required this.hintText,
    required TextEditingController descriptionController,
  }) : _descriptionController = descriptionController;

  final TextEditingController _descriptionController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // 上下の余白を追加
      child: TextFormField(
        maxLines: null,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        controller: _descriptionController,
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required TextEditingController titleController,
  }) : _titleController = titleController;

  final TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // 上下の余白を追加
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'タイトル',
          border: UnderlineInputBorder(),
        ),
        controller: _titleController,
      ),
    );
  }
}
