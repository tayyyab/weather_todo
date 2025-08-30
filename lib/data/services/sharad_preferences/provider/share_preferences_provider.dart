import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/data/services/sharad_preferences/shared_preferences_service.dart';

final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>(
  (ref) => SharedPreferencesService(),
);
