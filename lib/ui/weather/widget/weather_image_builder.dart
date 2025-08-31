import 'package:flutter/material.dart';

class WeatherImageBuilder extends StatelessWidget {
  const WeatherImageBuilder({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Image.asset(getWeatherIcons(name));
  }

  String getWeatherIcons(String value) {
    switch (value) {
      // Day time icons
      case '01d':
        return 'assets/weather/clear-sky.png';
      case '02d':
        return 'assets/weather/few-clouds.png';
      case '03d':
        return 'assets/weather/scattered-clouds.png';
      case '04d':
        return 'assets/weather/broken-clouds.png';
      case '09d':
        return 'assets/weather/shower-rain.png';
      case '10d':
        return 'assets/weather/rain.png';
      case '11d':
        return 'assets/weather/thunderstorm.png';
      case '13d':
        return 'assets/weather/snow.png';
      case '50d':
        return 'assets/weather/mist.png';

      // Night time icons
      case '01n':
        return 'assets/weather/clear-sky-night.png';
      case '02n':
        return 'assets/weather/few-clouds-night.png';
      case '03n':
        return 'assets/weather/scattered-clouds.png'; // fallback to day version
      case '04n':
        return 'assets/weather/broken-clouds.png'; // fallback to day version
      case '09n':
        return 'assets/weather/shower-rain.png'; // fallback to day version
      case '10n':
        return 'assets/weather/rain-night.png';
      case '11n':
        return 'assets/weather/thunderstorm.png'; // fallback to day version
      case '13n':
        return 'assets/weather/snow.png'; // fallback to day version
      case '50n':
        return 'assets/weather/mist.png'; // fallback to day version

      // Default fallback
      default:
        return 'assets/weather/clear-sky.png';
    }
  }
}
