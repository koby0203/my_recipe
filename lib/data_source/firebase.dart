// Flutter
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Recipeデータのやり取り
class FirestoreService {
  final db = FirebaseFirestore.instance;
  final root = "recipes";

  // 追加
  void add(String docName, Map<String, dynamic> data) {
    try {
      Map<String, dynamic> fData = data;
      db.collection(root).doc(docName).set(fData);
    } catch (e) {
      throw Exception();
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
  Stream<QuerySnapshot> getAll() {
    return db.collection(root).snapshots();
  }

  Stream<QuerySnapshot> search(String word) {
    return db
        .collection(root)
        .where(Filter.or(Filter("tag1", isEqualTo: word),
            Filter("tag2", isEqualTo: word), Filter("tag3", isEqualTo: word)))
        .snapshots();
  }

  // お気に入り追加
  void addFavorite(String docName) {
    try {
      db.collection(root).doc(docName).update({"favorite": true});
    } catch (e) {
      print('Error : $e');
    }
  }

  // お気に入り削除
  void deleteFavorite(String docName) {
    try {
      db.collection(root).doc(docName).update({"favorite": false});
    } catch (e) {
      print('Error : $e');
    }
  }

  // お気に入り取得
  Stream<QuerySnapshot> getFavorite() {
    return db.collection(root).where("favorite", isEqualTo: true).snapshots();
  }

  // 削除
  Future<void> delete(String docName) async {
    try {
      await db.collection(root).doc(docName).delete();
    } catch (e) {
      print('Error : $e');
    }
  }
}

// 画像ファイルのやり取り
class CloudStorageService {
  final root = "images";

  // アップロード
  void uploadImage(File file, String imageName) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child("$root/$imageName");
      await storageRef.putFile(file);
    } catch (e) {
      throw Exception();
    }
  }

  // ダウンロード
  Future<Uint8List?> downloadImage(String imageName) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child("$root/$imageName");
      const oneMegabyte = 1024 * 1024;
      return await storageRef.getData(oneMegabyte);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String> getImageURL(String imageName) async {
    try {
      // 画像のダウンロードURLを取得
      String downloadURL = await FirebaseStorage.instance
          .ref()
          .child("$root/$imageName")
          .getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('画像の取得中にエラーが発生しました: $e');
      return "";
    }
  }

  // 削除
  void deleteImage(String imageName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child("$root/$imageName");
    await storageRef.delete();
    } catch (e) {
      print('画像の削除に失敗しました。: $e');
    }
  }
}
