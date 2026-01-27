import 'package:clima_app/services/get_temperature.dart';
import 'package:flutter/material.dart';
import 'package:clima_app/services/get_location.dart';
import 'package:clima_app/components/get_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:clima_app/components/card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final locationServices = LocationServices();
  final temperatureServices = TemperatureServices();
  final customCard = CustomCard();
  final RefreshController _refreshController = RefreshController();

  String locationName = "fetching...";
  String currentTemperature = "fetching...";
  String iconUrl = "";
  String currentTemperatureCondition = "fetching";
  List<List<String>> forecast = [];

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
    _fetchForecast();
  }

  //function to refresh data
  Future<void> _onRefresh() async {
    try {
      // Reset data to show fetching status
      setState(() {
        locationName = "fetching...";
        currentTemperature = "fetching...";
        currentTemperatureCondition = "fetching";
      });

      temperatureServices.clearCache(); //first clearing cache for fresh data

      await Future.wait([
        _fetchLocation(),
        _fetchTemperature(),
        _fetchForecast(),
      ]);

      // Add a small delay so the user sees the refresh indicator
      await Future.delayed(Duration(milliseconds: 500));

      _refreshController.refreshCompleted();
    } catch (err) {
      print("Refresh error: $err");
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

  //function to get weather forecast for three days
  Future<void> _fetchForecast() async {
    try {
      final fetchedForecast =
          await temperatureServices.getDetailsAboutForecast();
      setState(() {
        forecast = fetchedForecast;
      });
    } catch (err) {
      setState(() {
        forecast = []; // Set to empty on error
      });
      throw Exception("Error happened : $err");
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF001E34), Color(0xFF00866E)],
        ),
      ),
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropMaterialHeader(
          color: Colors.white,
          // waterDropColor: Colors.white,
        ),
        onRefresh: _onRefresh,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          children: [
            SizedBox(height: 140),
            // Date
            Center(
              child: Text(
                "${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Location
            Center(
              child: Text(
                locationName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),

            // Weather Icon
            Center(
              child: GetIconFromUrl(
                url: iconUrl,
                color: Colors.white,
                size: 100,
              ),
            ),
            SizedBox(height: 16),

            // Weather Description
            Center(
              child: Text(
                currentTemperatureCondition,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(height: 16),

            // Current Temperature
            Center(
              child: Text(
                '$currentTemperature °C',
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 40),

            // Forecast
            if (forecast.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            else
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < forecast.length; i++)
                      customCard.buildCard(
                        GetIconFromUrl(
                          url: forecast[i][0],
                          color: Colors.white,
                          size: 50,
                        ),
                        "${forecast[i][1]}°C",
                        text:
                            i == 0
                                ? "Today"
                                : i == 1
                                ? "Tomorrow"
                                : "Day After",
                      ),
                  ],
                ),
              ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

//
