// Flutter
import 'dart:io';
import 'dart:typed_data';
// Firebase
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 画像ファイルのやり取り
class CloudStorageService {
  // UserIDの取得
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  // アップロード
  void uploadImage(String path, String name) async {
    try {
      File file = File(path);
      final storageRef =
          FirebaseStorage.instance.ref().child('users/$userID/$name');
      final task = await storageRef.putFile(file);
    } catch (e) {
      print(e);
    }
  }

  // ダウンロード
  Future<Uint8List?> downloadImage(String name) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('users/$userID/$name');
      const oneMegabyte = 1024 * 1024;
      return await storageRef.getData(oneMegabyte);
    } catch (e) {
      print(e);
    }
    return null;
  }

  // 削除
  void deleteImage(String name) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('users/$userID/$name');
    await storageRef.delete();
  }
}