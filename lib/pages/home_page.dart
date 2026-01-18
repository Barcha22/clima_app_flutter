import 'package:clima_app/services/get_temperature.dart';
import 'package:flutter/material.dart';
import 'package:clima_app/services/get_location.dart';
import 'package:clima_app/components/get_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final locationServices = LocationServices();
  final temperatureServices = TemperatureServices();
  final RefreshController _refreshController = RefreshController();

  String locationName = "fetching...";
  String currentTemperature = "fetching...";
  String iconUrl = "";
  String currentTemperatureCondition = "fetching";

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

  //function to refresh data
  Future<void> _onRefresh() async {
    try {
      temperatureServices.clearCache(); //first clearing cache for fresh data

      await Future.wait([_fetchLocation(), _fetchTemperature()]);

      _refreshController.refreshCompleted();
    } catch (err) {
      _refreshController.refreshFailed();
    }
  }

  //function to get temperature details
  Future<void> _fetchTemperature() async {
    try {
      final currentTemp =
          await temperatureServices.getDetailsAboutTemperature();
      setState(() {
        currentTemperature = currentTemp[0];
        iconUrl = currentTemp[1];
        currentTemperatureCondition = currentTemp[2];
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
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Stack(
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
                  height: 70,
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
                  margin: EdgeInsets.only(top: 30),
                  height: 120,
                  child: GetIconFromUrl(url: iconUrl, color: Colors.white),
                ),
                //description
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 30,
                  child: Text(
                    currentTemperatureCondition,
                    style: TextStyle(
                      color: Colors.white, //
                      fontSize: 25,
                    ),
                  ),
                ),
                //current temperature
                Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 120,
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
      ),
    );
  }
}
