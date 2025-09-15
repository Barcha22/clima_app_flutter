import 'dart:convert';
import 'package:http/http.dart';
import 'location.dart';

class WeatherService {
  Location loc;
  String key = 'ENTER_YOUR_API_KEY_HERE';

  WeatherService(this.loc);
  //function to get location with longitude and latitude
  Future<Map<String, dynamic>?> getWeatherCoordinates() async {
    try {
      await loc.getLatLong();

      if (loc.lat == null || loc.long == null) {
        await loc.getLatLong();
      }
      String url =
          'http://api.weatherapi.com/v1/forecast.json?key=$key&q=${loc.lat},${loc.long}&days=6';

      final response = await get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final forecastDays = data['forecast']['forecastday'] as List;

        List<Map<String, dynamic>> processedForecast = [];
        for (var day in forecastDays) {
          processedForecast.add({
            'date': day['date'],
            'maxTemp': day['day']['maxtemp_c'],
            'minTemp': day['day']['mintemp_c'],
            'condition': day['day']['condition']['text'],
            'icon': day['day']['condition']['icon'],
            'avgTemp': day['day']['avgtemp_c'],
          });
        }
        return {
          'current': data['current'],
          'location': data['location'],
          'forecast': processedForecast,
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //function to get weather with city name
  Future<Map<String, dynamic>?> getWeatherName(String? city) async {
    if (city == null || city.isEmpty) {
      return null;
    }
    String url =
        'http://api.weatherapi.com/v1/forecast.json?key=$key&q=${city}';

    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final cityName = data['location']['name'];
      final temp = data['current']['temp_c'];
      final weather = data['current']['condition']['text'];

      return {'city': cityName, 'temp': temp, 'weather': weather};
    }
    return null;
  }
}
