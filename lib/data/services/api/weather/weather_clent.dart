import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:weather_todo/data/services/api/weather/models/weather_request.dart';
import 'package:weather_todo/data/services/api/weather/models/weather_response.dart';

abstract class WeatherApiClient {
  Future<WeatherResponseModel> getWeather(GetWeatherRequest model);
}

// https://api.openweathermap.org/data/2.5/weather?lat=33.44&lon=-94.04&appid=9204923cd5eb84a4df4ac1053842d481

const baseUrl = "https://api.openweathermap.org/data/";
const version = '2.5/';
const apikey = '9204923cd5eb84a4df4ac1053842d481';

class WeatherClientImpl extends WeatherApiClient {
  final _client = Dio();

  @override
  Future<WeatherResponseModel> getWeather(GetWeatherRequest model) async {
    final response = await _client.get(
      // "$baseUrl${version}weather?lat=${model.latitude}&lon=${model.longitude}&appid=$apikey",
      "$baseUrl${version}forecast?lat=${model.latitude}&lon=${model.longitude}&appid=$apikey",
    );

    return WeatherResponseModel.fromJson(response.data);
  }
}
