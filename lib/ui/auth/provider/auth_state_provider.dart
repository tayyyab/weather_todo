import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/data/repository/authentication/auth_repository.dart';
import 'package:weather_todo/data/repository/authentication/provider/auth_repository_provider.dart';
import 'package:weather_todo/utils/result.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((
  ref,
) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(authRepository);
});

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  AuthState({
    required this.isAuthenticated,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({bool? isAuthenticated, bool? isLoading, String? error}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthStateNotifier(this._authRepository)
    : super(AuthState(isAuthenticated: false)) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isAuth = await _authRepository.isAuthenticated;
    state = state.copyWith(isAuthenticated: isAuth);
  }

  Future<Result> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _authRepository.login(username, password);

    result.when(
      success: (msg) {
        state = state.copyWith(isAuthenticated: true, isLoading: false);
      },
      failure: (msg) {
        state = state.copyWith(isLoading: false, error: msg);
      },
    );
    return result;
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = state.copyWith(isAuthenticated: false);
  }
}
