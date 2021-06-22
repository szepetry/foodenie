import 'package:geolocator/geolocator.dart';


class CurrentLocation {
  double latitude=5;
  double longitude;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print("error");
      print(e);
    }
  }
}