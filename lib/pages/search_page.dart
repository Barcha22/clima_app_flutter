import 'package:flutter/material.dart';
import 'package:clima_app/services/get_temperature.dart';
import 'package:clima_app/components/get_icons.dart';
import 'package:clima_app/data/cities.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final temperatureServices = TemperatureServices();
  late TextEditingController _searchController;
  bool _loading = false;
  String? cityName;
  String? currentTemp;
  String? iconUrl;
  String? conditionText;
  bool _showing = false;
  List<String> _suggestions = [];
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  void _showSuggestionsOverlay() {
    // Always remove old overlay first to recreate with updated suggestions
    _removeSuggestionsOverlay();

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 214,
            left: MediaQuery.of(context).size.width / 2 - 175,
            width: 350,
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(maxHeight: 250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _suggestions.length > 5 ? 5 : _suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_suggestions[index]),
                      onTap: () {
                        _searchController.text = _suggestions[index];
                        _handleSubmit(_suggestions[index]);
                        _removeSuggestionsOverlay();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeSuggestionsOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _removeSuggestionsOverlay();
    super.dispose();
  }

  //function to update suggestions in the searchbar
  void _updateSuggestions(String input) {
    if (input.isEmpty) {
      _removeSuggestionsOverlay();
      return;
    }

    final filtered =
        citiesList
            .where((city) => city.toLowerCase().startsWith(input.toLowerCase()))
            .toList();

    setState(() {
      _suggestions = filtered;
    });

    if (filtered.isNotEmpty) {
      _showSuggestionsOverlay();
    } else {
      _removeSuggestionsOverlay();
    }
  }

  //function to get the current weather for the city
  Future<void> _getCity(String city) async {
    final results = await temperatureServices.getCurrentTempForSpecificCity(
      city,
    );
    setState(() {
      cityName = city;
      currentTemp = "${results[0]}°C";
      iconUrl = results[1].toString();
      conditionText = results[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF001E34), Color(0xFF00866E)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 100),

          // Searchbar
          SizedBox(
            width: 350,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "A city name...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _updateSuggestions(value);
              },
              onSubmitted: (cityname) {
                _handleSubmit(cityname);
                _searchController.clear();
                _removeSuggestionsOverlay();
              },
            ),
          ),

          //content
          SizedBox(height: 130),
          _showing
              ? Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                child:
                    _loading
                        ? CircularProgressIndicator()
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cityName ?? "--",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            GetIconFromUrl(
                              url: iconUrl.toString(),
                              size: 100,
                              color: Colors.white,
                            ), //
                            SizedBox(height: 20),
                            Text(
                              currentTemp ?? "-- °C",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              conditionText ?? "Condition",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
              )
              : SizedBox(height: 100),

          //--------function to check if the search bar is focused---------
        ],
      ),
    );
  }

  Future<void> _handleSubmit(String cityname) async {
    try {
      if (cityname.trim().isEmpty) return;

      // Validate that the city exists in our list (case-insensitive)
      final isValidCity = citiesList.any(
        (city) => city.toLowerCase() == cityname.trim().toLowerCase(),
      );

      if (!isValidCity) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('City "$cityname" not found in our database'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      setState(() {
        _loading = true;
        _showing = true;
      });
      await _getCity(cityname);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      throw Exception("error : ${e}");
    }
  }
}
