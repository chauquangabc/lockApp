import 'package:flutter/material.dart';
import 'package:lock_application/view/user/home_screen.dart';
import 'package:lock_application/view/user/profile_screen.dart';
import 'package:lock_application/view/user/setting_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> _widgets = [];
  int _index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _widgets = [HomeScreen(), ProfileScreen(), SettingScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _widgets),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.house), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.man), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}
