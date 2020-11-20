import 'package:flutter/material.dart';
import 'package:blog_app/pages/homepage.dart';
import 'package:blog_app/pages/newpost.dart';
import 'package:blog_app/pages/profilepage.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  List<BottomNavigationBarItem> _items;
  String _value = '';
  int _index = 0;
  final _pageOptions = [
    HomePage(),
    NewPost(),
    ProfilePage()
  ];

  @override
  void initState()
  {
    _items = List();
    _items.add(BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat'))));
    _items.add(BottomNavigationBarItem(icon: Icon(Icons.library_add_outlined), title: Text('New Post', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat'))));
    _items.add(BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat'))));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pageOptions[_index],
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        fixedColor: Colors.white,
        backgroundColor: Colors.lightBlueAccent,
        currentIndex: _index,
        onTap: (int item)
        {
          setState(() {
            _index = item;
          });
        },
      ),
    );
  }
}