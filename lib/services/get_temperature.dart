import 'package:http/http.dart' as http;
import 'package:clima_app/services/get_location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class TemperatureServices {
  final coordinates = LocationServices();
  Map<String, dynamic>? _cachedData;

  //0. function to make api call
  Future<Map<String, dynamic>> makeApiCall() async {
    if (_cachedData != null) {
      return _cachedData!;
    }
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
      if (response.statusCode == 200) {
        _cachedData = jsonDecode(response.body);
        return _cachedData!;
      } else {
        return Future.error("Future Error happened");
      }
    } catch (err) {
      throw Exception("An error occured while making api call.");
    }
  }

  //1. function to get temperature details
  Future<List<String>> getDetailsAboutTemperature() async {
    try {
      final jsonData = await makeApiCall();
      return [
        jsonData['current']['temp_c']
            .toString(), //current temperature in celcius
        jsonData['current']['condition']['icon']
            .toString(), //current temperatures icon
        jsonData['current']['condition']['text']
            .toString(), //current temperatures condition
      ];
    } catch (err) {
      throw Exception("custom[ERROR] : $err");
    }
  }

  void clearCache() {
    _cachedData = null;
  }
}
