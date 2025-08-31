import 'package:weather_todo/data/services/api/weather/models/weather_request.dart';
import 'package:weather_todo/data/services/api/weather/models/weather_response.dart';

abstract class WeatherRepository {
  Future<WeatherResponseModel> getWeatherData(GetWeatherRequest model);
}
