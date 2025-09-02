import 'package:dio/dio.dart';
import 'package:weather_todo/data/services/api/weather/models/weather_request.dart';
import 'package:weather_todo/data/services/api/weather/models/weather_response.dart';
import 'package:weather_todo/domain/exceptions/weather_exception.dart';

abstract class WeatherApiClient {
  Future<WeatherResponseModel> getWeather(GetWeatherRequest model);
}

const baseUrl = "https://api.openweathermap.org/data/";
const version = '2.5/';
const apikey = '9204923cd5eb84a4df4ac1053842d481';

class WeatherClientImpl extends WeatherApiClient {
  final _client = Dio();

  @override
  Future<WeatherResponseModel> getWeather(GetWeatherRequest model) async {
    final response = await _client
        .get(
          // "$baseUrl${version}weather?lat=${model.latitude}&lon=${model.longitude}&appid=$apikey",
          "$baseUrl${version}forecast?lat=${model.latitude}&lon=${model.longitude}&appid=$apikey",
        )
        .onError((error, stackTrace) {
          throw WeatherException(
            'Failed to fetch weather data',
            details: error.toString(),
          );
        });

    return WeatherResponseModel.fromJson(response.data);
  }
}
