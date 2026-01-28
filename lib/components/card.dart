import 'package:flutter/material.dart';

class CustomCard {
  Widget buildCard(Widget icon, String temp, {required String text}) {
    return Column(
      children: [
        //the date above
        Text(text, style: TextStyle(color: Colors.white)),
        SizedBox(height: 7),
        //the card
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //icon
              icon,
              SizedBox(height: 15),
              //temperature for the day
              Text(temp, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}
