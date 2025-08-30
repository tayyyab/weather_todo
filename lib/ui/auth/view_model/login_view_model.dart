import 'package:weather_todo/data/repository/authentication/auth_repository.dart';
import 'package:weather_todo/utils/result.dart';

class LoginViewModel {
  final AuthRepository _authRepository;

  String username = '';
  String password = '';

  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

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
    return await _authRepository.login(username, password);
  }
}
