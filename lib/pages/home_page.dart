import 'package:clima_app/services/get_temperature.dart';
import 'package:flutter/material.dart';
import 'package:clima_app/services/get_location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final locationServices = LocationServices();
  final temperatureServices = TemperatureServices();

  String locationName = "fetching...";
  String currentTemperature = "fetching...";
  DateTime now = DateTime.now();
  static const List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _fetchLocation();
    _fetchTemperature();
  }

  //function to get current temperature
  Future<void> _fetchTemperature() async {
    try {
      final currentTemp = await temperatureServices.getCurrentTemperature();
      setState(() {
        currentTemperature = currentTemp;
      });
    } catch (err) {
      setState(() {
        currentTemperature = "Error loading temp";
      });
    }
  }

  //function to get location
  Future<void> _fetchLocation() async {
    try {
      final cityCountry = await locationServices.getCurrentCityCountry();
      setState(() {
        locationName = cityCountry;
      });
    } catch (err) {
      setState(() {
        locationName = "Error loading location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body
      body: Stack(
        fit: StackFit.expand,
        children: [
          //to show the background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF001E34), Color(0xFF00866E)],
                ),
              ),
            ),
          ),
          //contianer to display locatoin
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //day
              Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  "${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}",
                  style: TextStyle(
                    fontSize: 28, //
                    color: Colors.white70,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              //location
              Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  locationName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white, //
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //icon
              Container(
                margin: EdgeInsets.only(top: 50),
                child: Text("ICON HERE"),
              ),
              //description
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text("DESCRIPTION HERE"),
              ),
              //current temperature
              Container(
                margin: EdgeInsets.only(top: 90),
                child: Text(
                  '$currentTemperature °C',
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.white, //
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
