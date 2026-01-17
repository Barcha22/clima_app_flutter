import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationServices {
  //1. function to get the current location lat and long
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled =
        await Geolocator.isLocationServiceEnabled(); //store wether the permission is given or not

    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    //check the permissoins
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied.");
      }
    }
    //checking if they are denied forever
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are denied forever.");
    }

    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    //else return the current location
    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  //2. function to get the current city and country via that location
  Future<String> getCurrentCityCountry() async {
    try {
      Position position = await getCurrentLocation();

      //convert to city and country
      List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude, //
        position.longitude,
      );

      if (placemark.isNotEmpty) {
        Placemark place = placemark[0];

        return "${place.locality ?? place.administrativeArea},"
            " ${place.country}";
      }
      return "unknown location";
    } catch (err) {
      throw Exception("custom [ERROR] : $err");
    }
  }
}
