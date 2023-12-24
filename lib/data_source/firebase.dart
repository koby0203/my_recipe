// Flutter
import 'dart:io';
import 'dart:typed_data';
// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Recipeデータのやり取り
class FirestoreService {
  final db = FirebaseFirestore.instance;
  final root = "recipes";

  // UserIDの取得
  final userID = FirebaseAuth.instance.currentUser?.uid ?? 'test';

  // 追加
  void add(String docName, Map<String, dynamic> data) {
    try {
      Map<String, dynamic> fData = data;
      fData["author"] = userID;
      db.collection(root).doc(docName).set(fData);
    } catch (e) {
      print('Error : $e');
    }
  }

  // 更新
  void update(String docName, Map<String, dynamic> data) {
    try {
      db.collection(root).doc(docName).update(data);
    } catch (e) {
      print('Error : $e');
    }
  }

  // 全件取得
  Future<dynamic> getAll() async {
    try {
      final QuerySnapshot querySnapshot = await db.collection(root).get();
      final dataes = querySnapshot.docs;
      return dataes;
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  // カテゴリ別全件取得
  Future<dynamic> getAllByCategory(String category) async {
    try {
      final QuerySnapshot querySnapshot = await db.collection(root).where('category', isEqualTo: category).get();
      final dataes = querySnapshot.docs;
      return dataes;
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  // 一件取得
  Future<Map<String, dynamic>?> getOne(String docName) async {
    try {
      final DocumentSnapshot doc = await db.collection(root).doc(docName).get();
      final data = doc.data() as Map<String, dynamic>;
      return data;
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  // 削除（ログインユーザのみ可能）
  void delete(String docName) async {
    try {
      db.collection(root).doc(docName).delete();
    } catch (e) {
      print('Error : $e');
    }
  }
}

// 画像ファイルのやり取り
class CloudStorageService {
  // UserIDの取得
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  // アップロード（ログインユーザのみ可能）
  void uploadImage(String path, String name) async {
    try {
      File file = File(path);
      final storageRef =
          FirebaseStorage.instance.ref().child('$userID/$name');
      final task = await storageRef.putFile(file);
    } catch (e) {
      print(e);
    }
  }

  // ダウンロード（全ユーザ可能）
  Future<Uint8List?> downloadImage(String path) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child(path);
      const oneMegabyte = 1024 * 1024;
      return await storageRef.getData(oneMegabyte);
    } catch (e) {
      print(e);
    }
    return null;
  }

  // 削除（ログインユーザのみ可能）
  void deleteImage(String name) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('$userID/$name');
    await storageRef.delete();
  }
}