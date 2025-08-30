import 'package:weather_todo/data/repository/authentication/auth_repository.dart';
import 'package:weather_todo/data/services/api/auth/auth_client.dart';
import 'package:weather_todo/data/services/sharad_preferences/shared_preferences_service.dart';
import 'package:weather_todo/utils/result.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({
    required AuthClient authApiClient,
    required SharedPreferencesService sharedPreferencesService,
  }) : _authApiClient = authApiClient,
       _sharedPreferencesService = sharedPreferencesService;

  bool? _isAuthenticated;
  final AuthClient _authApiClient;
  final SharedPreferencesService _sharedPreferencesService;

  @override
  Future<bool> get isAuthenticated async {
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    await _fetch();
    return _isAuthenticated ?? false;
  }

  Future<void> _fetch() async {
    var isLoggedIn = await _sharedPreferencesService.getIsLogin();
    _isAuthenticated = isLoggedIn;
    notifyListeners();
  }

  @override
  Future<Result> login(String username, String password) async {
    final success = await _authApiClient.login(username, password);
    if (success) {
      await _sharedPreferencesService.saveIsLogin(true);
      return Result.success('Login successful');
    } else {
      return Result.failure('Invalid username or password');
    }
  }

  @override
  Future<Result<String>> logout() async {
    await _sharedPreferencesService.saveIsLogin(false);
    return Result.success('Logout successful');
  }
}
