import 'package:weather_todo/utils/result.dart';

abstract class AuthRepository {
  /// Returns whether the user is authenticated.
  Future<bool> get isAuthenticated;

  /// Logs in the user with the given [username] and [password].
  Future<Result> login(String username, String password);

  /// Logs out the current user.
  Future<Result> logout();
}
