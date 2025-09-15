import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Location {
  double? lat;
  double? long;

  Location();

  //function that gets coordinates(latitude and longitude)
  Future<void> getLatLong() async {
    //1. check for permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }
    //2. if permission is granted then proceed to getting coordinates
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      lat = position.latitude;
      long = position.longitude;
    } catch (e) {
      // print('Error occured.$e');
    }
  }

  //AFTER EXTRACTING COORDINATES WE CAN NOW FIND OUT THE CITY
  Future<String> getCity() async {
    //3. Call the above function to get coordinates
    await getLatLong();
    //4. check if the coordinates are null or not
    if (lat == null || long == null) {
      return "Location coordinates not available";
    }
    //5. finally try to find the placemark from placemarkfromcoordinates to get city
    // locality is city and country is country
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(lat!, long!);
      return "${placemark[0].locality}, ${placemark[0].country}";
    } catch (e) {
      return "Location Unavailable";
    }
  }
}
