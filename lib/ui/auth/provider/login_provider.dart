import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/data/repository/authentication/auth_repository.dart';
import 'package:weather_todo/data/repository/authentication/provider/auth_repository_provider.dart';
import 'package:weather_todo/ui/auth/view_model/login_view_model.dart';

final loginViewModelProvider = Provider<LoginViewModel>((ref) {
  final AuthRepository authRepository = ref.watch(authRepositoryProvider);
  return LoginViewModel(authRepository: authRepository);
});
