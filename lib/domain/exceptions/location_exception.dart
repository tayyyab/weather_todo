class LocationException implements Exception {
  final String message;
  final String details;
  LocationException(this.message, {this.details = ''});

  @override
  String toString() {
    return 'Location issue: $message\nDetails: $details';
  }
}
