import 'package:clima_app/services/get_temperature.dart';
import 'package:flutter/material.dart';
import 'package:clima_app/services/get_location.dart';
import 'package:clima_app/components/get_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:clima_app/components/card.dart';
import 'package:shimmer/shimmer.dart';

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
  bool _isLoading = true;

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
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _fetchLocation(),
      _fetchTemperature(),
      _fetchForecast(),
    ]);
    setState(() => _isLoading = false);
  }

  //function to refresh data
  Future<void> _onRefresh() async {
    try {
      setState(() => _isLoading = true);
      temperatureServices.clearCache();

      await Future.wait([
        _fetchLocation(),
        _fetchTemperature(),
        _fetchForecast(),
      ]);

      await Future.delayed(Duration(milliseconds: 500));
      setState(() => _isLoading = false);
      _refreshController.refreshCompleted();
    } catch (err) {
      print("Refresh error: $err");
      setState(() => _isLoading = false);
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

  String _getDateLabel(int daysOffset) {
    DateTime date = now.add(Duration(days: daysOffset));
    String monthName = months[date.month - 1].toLowerCase();
    return "$monthName, ${date.day}";
  }

  // functions for skeleton loaders
  Widget _buildLocationSkeleton() {
    return SizedBox(
      height: 35,
      width: 200,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[200]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildTemperatureSkeleton() {
    return SizedBox(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[200]!,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[200]!,
            child: Container(
              height: 20,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[200]!,
            child: Container(
              height: 70,
              width: 220,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastSkeleton() {
    return SizedBox(
      height: 120,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < 3; i++)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[200]!,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[200]!,
                    child: Container(
                      height: 16,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[200]!,
                    child: Container(
                      height: 16,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
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
          backgroundColor: Colors.transparent,
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
              child:
                  _isLoading
                      ? _buildLocationSkeleton()
                      : Text(
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
            _isLoading
                ? Center(child: _buildTemperatureSkeleton())
                : Column(
                  children: [
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
                  ],
                ),
            SizedBox(height: 40),

            // Forecast
            _isLoading
                ? _buildForecastSkeleton()
                : (forecast.isEmpty
                    ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                    : Center(
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
                              text: _getDateLabel(i),
                            ),
                        ],
                      ),
                    )),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

//
