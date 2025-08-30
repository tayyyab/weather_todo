import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/data/repository/authentication/auth_repository.dart';
import 'package:weather_todo/data/repository/authentication/auth_repository_impl.dart';
import 'package:weather_todo/data/services/api/auth/provider/auth_client_provider.dart';
import 'package:weather_todo/data/services/sharad_preferences/provider/share_preferences_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authClient = ref.watch(authClientProvider);
  final sharedPreferencesService = ref.watch(sharedPreferencesServiceProvider);
  return AuthRepositoryImpl(
    authApiClient: authClient,
    sharedPreferencesService: sharedPreferencesService,
  );
});
