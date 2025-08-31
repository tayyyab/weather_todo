import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/ui/auth/provider/auth_state_provider.dart';
import 'package:weather_todo/ui/auth/view_model/login_view_model.dart';

final loginViewModelProvider = Provider.autoDispose<LoginViewModel>((ref) {
  final AuthStateNotifier authNotifier = ref.watch(authStateProvider.notifier);
  return LoginViewModel(authNotifier: authNotifier);
});
