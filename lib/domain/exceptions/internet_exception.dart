class InternetException implements Exception {
  final String message;
  final String details;
  InternetException(this.message, {this.details = ''});

  @override
  String toString() {
    return 'Internet issue: $message\nDetails: $details';
  }
}
