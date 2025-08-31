import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/data/services/api/weather/weather_clent.dart';

final weatherClientProvider = Provider((ref) => WeatherClientImpl());
