import 'package:http/http.dart' as http;
import 'package:clima_app/services/get_location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class TemperatureServices {
  final coordinates = LocationServices();
  Map<String, dynamic>? _cachedData;
  Map<String, dynamic>? _cachedForecast;

  //0a. function to make api call for current location
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

  //1a. function to get temperature details
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

  //0b. function make api call for 3 days forecast
  Future<Map<String, dynamic>> makeApiCalls() async {
    if (_cachedForecast != null) {
      return _cachedForecast!;
    }
    try {
      final position = await coordinates.getCurrentLocation();
      final apiKey = dotenv.env["MY_API"] ?? ' ';
      if (apiKey.isEmpty) {
        throw Exception("Api key not found in .env");
      }
      final response = await http.get(
        Uri.parse(
          "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=${position.latitude},${position.longitude}&days=3",
        ),
      );
      if (response.statusCode == 200) {
        _cachedForecast = jsonDecode(response.body);
        return _cachedForecast!;
      } else {
        return Future.error("error happened while making api call");
      }
    } catch (e) {
      throw Exception("An error happend : $e");
    }
  }

  //1b. function to get temperature forecast for 3 days
  Future<List<List<String>>> getDetailsAboutForecast() async {
    try {
      final jsonData = await makeApiCalls();
      List<List<String>> forecastData = [];
      for (var forecastDay in jsonData['forecast']['forecastday']) {
        final iconUrl = forecastDay['day']['condition']['icon'];
        final currentTemp = forecastDay['day']['maxtemp_c'];
        forecastData.add([iconUrl.toString(), currentTemp.toString()]);
      }
      return forecastData;
    } catch (err) {
      throw Exception("error happened : $err");
    }
  }

  //2. function to get current temp only for a location that is searched
  Future<List<String>> getCurrentTempForSpecificCity(city) async {
    try {
      final _city = city;
      //get the apikey
      final apiKey = dotenv.env["MY_API"] ?? '';
      if (apiKey.isEmpty) {
        throw Exception("Api key not found in .env");
      }
      //make api call
      final response = await http.get(
        Uri.parse(
          "http://api.weatherapi.com/v1/current.json?key=$apiKey&q=${_city}",
        ),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return [
          jsonData['current']['temp_c']
              .toString(), //current temperature in celcius
          jsonData['current']['condition']['icon']
              .toString(), //current temperatures icon
          jsonData['current']['condition']['text']
              .toString(), //current temperatures condition
        ];
      } else {
        return Future.error("Future Error happened");
      }
    } catch (err) {
      throw Exception("An error occured while making api call.");
    }
  }

  void clearCache() {
    _cachedData = null;
    _cachedForecast = null;
  }
}
