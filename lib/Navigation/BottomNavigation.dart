import 'package:flutter/material.dart';
import 'package:kubera_app/Pages/HomePage.dart';
import 'package:kubera_app/Pages/Library/MyLibrary.dart';
import 'package:kubera_app/Pages/Support/SupportPagw.dart';
import 'package:kubera_app/Pages/Tree/TreePage.dart';

class BottomNavigation extends StatefulWidget {
  final int index;
  BottomNavigation({
    Key key,
    this.index,
  }) : super(key: key);
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = widget.index;
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return HomePage();
          }),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return LibraryPage();
          }),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return TreePage();
          }),
        );
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return SupportPage();
          }),
        );
      }
    });
  }

  _loadInitial() async {
    setState(() {
      _selectedIndex = widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueGrey[900],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(''),
            backgroundColor: Colors.blueGrey[900],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_library_sharp),
            title: Text(''),
            backgroundColor: Colors.blueGrey[900],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text(''),
            backgroundColor: Colors.blueGrey[900],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text(''),
            backgroundColor: Colors.blueGrey[900],
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        iconSize: 26,
        onTap: _onItemTapped,
        elevation: 0);
  }
}
