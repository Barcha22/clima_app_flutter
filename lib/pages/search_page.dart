import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textController = TextEditingController();
  final cities = ["berlin", "newyork"];
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF001E34), Color(0xFF00866E)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 100),

          // Searchbar
          SizedBox(
            width: 350,
            child: Focus(
              onFocusChange:
                  (value) => {
                    setState(() {
                      _isFocused = value;
                    }),
                  },
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "A city name...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), //
                  ),
                ),
              ),
            ),
          ),

          //--------function to check if the search bar is focused---------
        ],
      ),
    );
  }
}
