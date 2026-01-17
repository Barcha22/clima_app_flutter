import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:clima_app/services/get_location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TemperatureServices {
  final coordinates = LocationServices();

  //1. function to get temperature for current day
  Future<String> getCurrentTemperature() async {
    try {
      // collect the coordinates
      final position = await coordinates.getCurrentLocation();
      //get the apikey
      final apiKey = dotenv.env["MY_API"] ?? '';
      if (apiKey.isEmpty) {
        throw Exception("Api key not found in .env");
      }
      //make api call
      final response = await http.get(
        Uri.parse(
          "http://api.weatherapi.com/v1/current.json?key=$apiKey&q=${position.latitude},${position.longitude}",
        ),
      );
      //check if response was back
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['current']['temp_c'].toString();
      } else {
        throw Exception("custom[ERROR] : Api error");
      }
    } catch (err) {
      throw Exception("custom[ERROR] : $err");
    }
  }
}
