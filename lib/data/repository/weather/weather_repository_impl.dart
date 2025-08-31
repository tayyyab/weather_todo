import 'package:weather_todo/data/repository/weather/weather_repository.dart';
import 'package:weather_todo/data/services/api/weather/models/weather_request.dart';
import 'package:weather_todo/data/services/api/weather/models/weather_response.dart';
import 'package:weather_todo/data/services/api/weather/weather_clent.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherApiClient apiClient;

  WeatherRepositoryImpl(this.apiClient);

  @override
  Future<WeatherResponseModel> getWeatherData(GetWeatherRequest model) async {
    final response = await apiClient.getWeather(model);
    return response;
  }
}
