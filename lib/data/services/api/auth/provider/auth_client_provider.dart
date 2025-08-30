import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/data/services/api/auth/auth_client.dart';

final authClientProvider = Provider<AuthClient>((ref) {
  return AuthClient();
});
