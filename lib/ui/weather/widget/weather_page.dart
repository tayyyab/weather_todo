import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_todo/domain/exceptions/location_exception.dart';
import 'package:weather_todo/domain/exceptions/weather_exception.dart';
import 'package:weather_todo/ui/core/ui/widget/button.dart';
import 'package:weather_todo/ui/weather/view_model.dart/weather_vew_model.dart';
import 'package:weather_todo/ui/weather/widget/weather_image_builder.dart';

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var weather = ref.watch(weatherProvider);
    return RefreshIndicator(
      onRefresh: () async {
        // Trigger a refresh of the weather data
        ref.invalidate(weatherProvider);
      },
      child: Column(
        children: [
          Expanded(
            child: weather.when(
              data: (data) {
                if (data.list == null || data.list!.isEmpty) {
                  return const Center(child: Text('No weather data available'));
                }

                final cityName = data.city?.name ?? 'Unknown Location';
                final allWeatherData = data.list!;

                // Find the current or nearest time weather data
                final now = DateTime.now();
                final currentWeather = allWeatherData.reduce((a, b) {
                  final aDiff =
                      a.dtTxt?.difference(now).abs() ?? Duration(hours: 1);
                  final bDiff =
                      b.dtTxt?.difference(now).abs() ?? Duration(hours: 1);
                  return aDiff < bDiff ? a : b;
                });

                return Column(
                  children: [
                    // Current Weather - Big Display
                    _buildCurrentWeatherDisplay(currentWeather, cityName),

                    const SizedBox(height: 20),

                    // Horizontal List Title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '5-Day Forecast',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Horizontal Weather List
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: allWeatherData.length,
                        itemBuilder: (context, index) {
                          final weatherItem = allWeatherData[index];
                          final isCurrentWeather =
                              weatherItem == currentWeather;
                          return _buildHorizontalWeatherCard(
                            weatherItem,
                            isCurrentWeather,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                if (error is WeatherException) {
                  return Center(child: Text(error.message));
                } else if (error is LocationException) {
                  return Center(child: Text(error.message));
                }

                return Center(child: Text('Error: $error'));
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: SizedBox(
                width: 150,
                child: MyIconButton(
                  icon: Icon(Icons.location_city),
                  label: 'City Weather',
                  onPressed: () {
                    ref.invalidate(weatherProvider);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeatherDisplay(currentWeather, String cityName) {
    // Format the date properly
    final dateFormatter = DateFormat('EEEE, MMMM d, yyyy');
    final timeFormatter = DateFormat('hh:mm a');
    final formattedDate = currentWeather.dtTxt != null
        ? dateFormatter.format(currentWeather.dtTxt!)
        : 'Date unavailable';
    final formattedTime = currentWeather.dtTxt != null
        ? timeFormatter.format(currentWeather.dtTxt!)
        : 'Time unavailable';

    final temperature = currentWeather.main?.temp != null
        ? '${(currentWeather.main!.temp! - 273.15).round()}°C'
        : 'N/A';

    final description = currentWeather.weather?.isNotEmpty == true
        ? currentWeather.weather!.first.description ?? 'No description'
        : 'No description';

    final iconCode = currentWeather.weather?.isNotEmpty == true
        ? currentWeather.weather!.first.icon ?? '01d'
        : '01d';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // City name
          Text(
            cityName,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Date
          Text(
            formattedDate,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 4),

          // Time
          Text(
            formattedTime,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Weather icon
          WeatherImageBuilder(name: iconCode),
          const SizedBox(height: 16),

          // Temperature
          Text(
            temperature,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 8),

          // Weather description
          Text(
            description.toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              letterSpacing: 2,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalWeatherCard(weatherItem, bool isCurrentWeather) {
    final timeFormatter = DateFormat('hh:mm a');
    final dateFormatter = DateFormat('MMM d');

    final time = weatherItem.dtTxt != null
        ? timeFormatter.format(weatherItem.dtTxt!)
        : 'N/A';
    final date = weatherItem.dtTxt != null
        ? dateFormatter.format(weatherItem.dtTxt!)
        : 'N/A';

    final temperature = weatherItem.main?.temp != null
        ? '${(weatherItem.main!.temp! - 273.15).round()}°C'
        : 'N/A';

    final iconCode = weatherItem.weather?.isNotEmpty == true
        ? weatherItem.weather!.first.icon ?? '01d'
        : '01d';

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isCurrentWeather
            ? Colors.blue.withAlpha(10)
            : Colors.grey.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        border: isCurrentWeather
            ? Border.all(color: Colors.blue, width: 2)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Date
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isCurrentWeather
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isCurrentWeather ? Colors.blue : Colors.grey[600],
              ),
            ),
            // Time
            Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: isCurrentWeather ? Colors.blue : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 8),

            // Weather icon (smaller)
            SizedBox(
              width: 40,
              height: 40,
              child: WeatherImageBuilder(name: iconCode),
            ),
            const SizedBox(height: 8),

            // Temperature
            Text(
              temperature,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isCurrentWeather
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isCurrentWeather ? Colors.blue : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
