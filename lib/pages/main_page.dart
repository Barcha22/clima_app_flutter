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
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [HomePage(), SearchPage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),

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
              GestureDetector(
                child: Icon(
                  Icons.home,
                  color: _selectedIndex == 0 ? Colors.blue : Colors.white,
                ), //
                onTap: () => changePage(0),
              ),
              GestureDetector(
                child: Icon(
                  Icons.search,
                  color: _selectedIndex == 1 ? Colors.blue : Colors.white,
                ), //
                onTap: () => changePage(1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changePage(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
    });
  }
}
