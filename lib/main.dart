import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart'; //for background
import 'location.dart';
import 'temperature.dart';
import 'newPage.dart';

void main() {
  runApp(const Clima());
}

class Clima extends StatelessWidget {
  const Clima({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: const HomePage(), //
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/first': (context) => MapScreen(), //
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //parameters
  String cityName = "loading...";
  String currentTemp = "--";
  String currentWeather = "";
  Location location = Location(); //an object of location class
  late WeatherService weatherS;
  late WeatherType selectBg;
  List<Map<String, dynamic>> forecastData = [];

  //initState Method
  @override
  void initState() {
    super.initState();
    weatherS = WeatherService(location);
    selectBg = WeatherType.overcast; // Initialize selectBg
    getData();
  }

  void getData() async {
    getLocationData();
    getTemp();
  }

  void getLocationData() async {
    String result = await location.getCity();
    setState(() {
      cityName = result;
    });
  }

  void getTemp() async {
    Map<String, dynamic>? result = await weatherS.getWeatherCoordinates();
    setState(() {
      if (result != null) {
        // Extract data from weatherapi.com response
        currentTemp = "${result['current']['temp_c'].round()}°C";
        currentWeather = result['current']['condition']['text'];

        if (result['forecast'] != null) {
          List<Map<String, dynamic>> forecast = List<Map<String, dynamic>>.from(
            result['forecast'],
          );

          forecastData = forecast;
        }
      } else {
        currentTemp = "Temperature not available";
        currentWeather = "Weather not available";
      }
    });
    selectBG(currentWeather);
  }

  //Build Method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WeatherBg(
            weatherType: selectBg, //
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            left: 30,
            right: 30,
            bottom: 570,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //print city name
                Text(
                  cityName,
                  style: TextStyle(
                    fontSize: 25, //
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                //print weather
                Text(
                  currentTemp,
                  style: TextStyle(
                    fontSize: (currentTemp.length > 5) ? 25 : 50,
                    color: Colors.white, //
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //print additional details
                Text(
                  currentWeather,
                  style: TextStyle(
                    fontSize: 25, //
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          //for forecast
          Positioned(
            left: 10,
            right: 10,
            bottom: 200,
            child: SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var day in forecastData.skip(1))
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Date
                            Text(
                              _formatDate(day['date']),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),

                            // Weather Icon
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: Image.network(
                                'https:${day['icon']}',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.cloud,
                                    color: Colors.white,
                                    size: 24,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 4),

                            // Temperature
                            Text(
                              '${day['maxTemp'].round()}°',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${day['minTemp'].round()}°',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          //divider
          Positioned(
            right: 50,
            left: 50,
            bottom: 80,
            child: Divider(
              color: Colors.white, //
              thickness: 1,
            ),
          ),
          //appbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 20, //
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        //
                      },
                      child: Icon(Icons.sunny),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/first');
                      },
                      child: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
  }

  //for selecting the background
  void selectBG(String currentWeather) {
    String weather = currentWeather.toLowerCase();

    DateTime now = DateTime.now();
    int hour = now.hour;
    bool isNight = hour < 6 || hour > 19;

    setState(() {
      if (weather.contains('rain') || weather.contains('drizzle')) {
        if (weather.contains('heavy')) {
          selectBg = WeatherType.heavyRainy;
        } else {
          selectBg = WeatherType.lightRainy;
        }
      } else if (weather.contains('snow')) {
        if (weather.contains('heavy')) {
          selectBg = WeatherType.heavySnow;
        } else {
          selectBg = WeatherType.lightSnow;
        }
      } else if (weather.contains('cloud') || weather.contains('partly')) {
        // Use time of day to determine cloudy vs cloudyNight
        if (isNight) {
          selectBg = WeatherType.cloudyNight;
        } else {
          selectBg = WeatherType.cloudy;
        }
      } else if (weather.contains('clear') || weather.contains('sunny')) {
        // Use time of day for clear weather too
        if (isNight) {
          selectBg =
              WeatherType
                  .sunnyNight; // If this exists, otherwise use cloudyNight
        } else {
          selectBg = WeatherType.sunny;
        }
      } else if (weather.contains('fog')) {
        selectBg = WeatherType.foggy;
      } else if (weather.contains('thunder')) {
        selectBg = WeatherType.thunder;
      } else if (weather.contains('overcast')) {
        selectBg = WeatherType.overcast;
      } else if (weather.contains('dust')) {
        selectBg = WeatherType.dusty;
      } else if (weather.contains('haze')) {
        selectBg = WeatherType.hazy;
      } else {
        // Default based on time of day
        if (isNight) {
          selectBg = WeatherType.cloudyNight;
        } else {
          selectBg = WeatherType.sunny;
        }
      }
    });
  }

  // Helper function to format date
  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      List<String> weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      return weekdays[date.weekday % 7];
    } catch (e) {
      return dateString.split('-').last; // Return day number if parsing fails
    }
  }
}
