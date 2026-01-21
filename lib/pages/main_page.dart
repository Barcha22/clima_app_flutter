import 'package:flutter/material.dart';
import 'package:clima_app/pages/home_page.dart';
import 'package:clima_app/pages/search_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [HomePage(), SearchPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1, 0), //
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [Color(0xFF001E34), Color(0xFF00866E)],
          ),
        ),
        child: BottomAppBar(
          padding: EdgeInsets.only(left: 40, right: 40, top: 20),
          height: 40,
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.home, color: Colors.white),
              Icon(Icons.search, color: Colors.white), //
            ],
          ),
        ),
      ),
    );
  }
}
