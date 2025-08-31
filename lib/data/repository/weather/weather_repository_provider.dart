import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/data/repository/weather/weather_repository.dart';
import 'package:weather_todo/data/repository/weather/weather_repository_impl.dart';
import 'package:weather_todo/data/services/api/weather/provider/weather_client_provider.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final weatherApiClient = ref.watch(weatherClientProvider);
  return WeatherRepositoryImpl(weatherApiClient);
});
