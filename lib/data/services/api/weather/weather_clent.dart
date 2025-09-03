import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:weather_todo/data/services/api/weather/models/weather_request.dart';
import 'package:weather_todo/data/services/api/weather/models/weather_response.dart';
import 'package:weather_todo/domain/exceptions/weather_exception.dart';

abstract class WeatherApiClient {
  Future<WeatherResponseModel> getWeather(GetWeatherRequest model);
}

class WeatherClientImpl extends WeatherApiClient {
  final _client = Dio();

  @override
  Future<WeatherResponseModel> getWeather(GetWeatherRequest model) async {
    var settings = await Configuration.readSetting();
    var baseUrl = settings['baseUrl'];
    var version = settings['version'];
    var apikey = settings['apiKey'];

    final response = await _client
        .get(
          "$baseUrl$version/forecast?lat=${model.latitude}&lon=${model.longitude}&appid=$apikey",
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

class Configuration {
  static Future<Map<String, dynamic>> readSetting() async {
    var data = await rootBundle.loadString('config.json');

    return json.decode(data);
  }
}
