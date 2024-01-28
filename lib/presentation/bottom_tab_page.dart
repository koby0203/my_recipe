import 'package:flutter/material.dart';
import 'package:my_recipe/presentation/auth_page.dart';
import 'package:my_recipe/presentation/favorite_page.dart';
import 'package:my_recipe/presentation/home_page.dart';
import 'package:my_recipe/presentation/post_page.dart';

class BottomTabPage extends StatefulWidget {
  BottomTabPage({
    Key? key,
    required this.index,
  }) : super(key: key);
  
  int index;
  
  @override
  State<StatefulWidget> createState() {
    return _BottomTabPageState();
  }
}

class _BottomTabPageState extends State<BottomTabPage> {

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }
  final _pageWidgets = [
    AuthPage(),
    HomePage(),
    const FavoritePage(),
    const PostPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidgets.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ユーザ認証'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'お気に入り'),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: '投稿'),
        ],
        currentIndex: _currentIndex,
        fixedColor: Colors.blueAccent,
        backgroundColor: const Color.fromARGB(255, 213, 239, 206),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _onItemTapped(int index) => setState(() => _currentIndex = index );
}