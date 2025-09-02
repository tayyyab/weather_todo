class WeatherException implements Exception {
  final String message;
  final String details;
  WeatherException(this.message, {this.details = ''});

  @override
  String toString() {
    return 'Weather issue: $message\nDetails: $details';
  }
}
