import 'package:weather_todo/ui/auth/provider/auth_state_provider.dart';
import 'package:weather_todo/utils/result.dart';

class LoginViewModel {
  final AuthStateNotifier _authNotifier;

  String username = '';
  String password = '';

  LoginViewModel({required AuthStateNotifier authNotifier})
    : _authNotifier = authNotifier;

  updateUsername(String? value) {
    username = value ?? '';
  }

  updatePassword(String? value) {
    password = value ?? '';
  }

  Future<Result> login() async {
    if (username.isEmpty || password.isEmpty) {
      return Result.failure('Username and password cannot be empty');
    }
    return await _authNotifier.login(username, password);
  }
}
