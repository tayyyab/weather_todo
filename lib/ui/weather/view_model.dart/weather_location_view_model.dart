import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

final weatherLocationProvider = Provider<WeatherLocationViewModel>(
  (ref) => WeatherLocationViewModel(),
);

class WeatherLocationViewModel {
  WeatherLocationViewModel();

  Future<LocationData?> getUserLocation() async {
    try {
      bool serviceEnabled = await Location.instance.serviceEnabled();
      if (!serviceEnabled) {
        bool isRequestGranted = await Location.instance.requestService();
        if (!isRequestGranted) {
          return null;
        }
      }
      PermissionStatus status = await Location.instance.hasPermission();
      if (status == PermissionStatus.denied) {
        status = await Location.instance.requestPermission();
        if (status != PermissionStatus.granted) {
          return null;
        }
      }

      LocationData locationData = await Location.instance.getLocation();
      return locationData;
    } catch (e) {
      rethrow;
    }
  }
}
