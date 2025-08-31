import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/data/repository/weather/weather_repository_provider.dart';
import 'package:weather_todo/data/services/api/weather/models/weather_request.dart';
import 'package:weather_todo/data/services/api/weather/models/weather_response.dart';
import 'package:weather_todo/ui/weather/view_model.dart/weather_location_view_model.dart';

final weatherProvider = AsyncNotifierProvider<Weather, WeatherResponseModel>(
  Weather.new,
);

class Weather extends AsyncNotifier<WeatherResponseModel> {
  @override
  Future<WeatherResponseModel> build() async {
    var location = await ref.read(weatherLocationProvider).getUserLocation();
    if (location == null) {
      throw Exception('Location not found');
    }
    final weatherData = await fetchWeatherData(
      location.latitude!,
      location.longitude!,
    );
    return weatherData;
  }

  Future<WeatherResponseModel> fetchWeatherData(
    double latitude,
    double longitude,
  ) async {
    var repo = ref.read(weatherRepositoryProvider);
    final weatherData = await repo.getWeatherData(
      GetWeatherRequest(latitude: latitude, longitude: longitude),
    );
    return weatherData;
  }
}
