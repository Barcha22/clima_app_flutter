import 'package:flutter/material.dart';
import 'temperature.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart'; //for background
import 'location.dart';

class MapScreen extends StatefulWidget {
  @override
  const MapScreen({super.key});

  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String city = "--";
  String? showCity;
  String? currentTemp;
  String? currentWeather;
  late WeatherService WS;
  WeatherType selectBg = WeatherType.sunny;
  @override
  void initState() {
    super.initState();
    WS = WeatherService(Location());
  }

  void getWeatherAgain() async {
    try {
      final data = await WS.getWeatherName(city);
      if (data != null) {
        setState(() {
          showCity = data['city'];
          currentTemp =
              "${data['temp'].round()}°C"; // Format temperature properly
          currentWeather = data['weather'];
        });
        selectBG(data['weather']);
      } else {
        setState(() {
          showCity = "City not found";
          currentTemp = "--";
          currentWeather = "--";
        });
      }
    } catch (e) {
      debugPrint('Error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //temporary background
      backgroundColor: Colors.indigoAccent, //
      //body
      body: Stack(
        children: [
          // search bar
          Positioned(
            left: 10,
            right: 10,
            top: 100,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter a city name",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (value) async {
                setState(() {
                  city = value.toUpperCase();
                  getWeatherAgain();
                });
              },
            ),
          ),
          //middle widget to show weather
          Center(
            child: Container(
              width: 350,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18), //
                child: Stack(
                  children: [
                    // Weather background only in container
                    WeatherBg(weatherType: selectBg, width: 350, height: 250),
                    // Content overlay
                    Container(
                      // padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (showCity == null) ? city : showCity ?? city,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            (currentTemp == null) ? "--" : currentTemp ?? "--",
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            (currentWeather == null)
                                ? "--"
                                : currentWeather ?? "--",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //divider using container
          Positioned(
            right: 50,
            left: 50,
            bottom: 80,
            child: Container(height: 1),
          ),
          //appbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: Icon(Icons.sunny),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        //
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
    );
  }

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
        if (isNight) {
          selectBg = WeatherType.cloudyNight;
        } else {
          selectBg = WeatherType.cloudy;
        }
      } else if (weather.contains('clear') || weather.contains('sunny')) {
        if (isNight) {
          selectBg = WeatherType.sunnyNight;
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
}
