import 'package:go_router/go_router.dart';
import 'package:weather_todo/data/repository/authentication/auth_repository.dart';
import 'package:weather_todo/routing/routes.dart';
import 'package:weather_todo/ui/auth/widget/login_screen.dart';

// GoRouter router(AuthRepository authRepository) => GoRouter(
GoRouter router() => GoRouter(
  initialLocation: Routes.login,
  // redirect: (context, state) async {
  //   final loggedIn = await authRepository.isAuthenticated;
  //   final loggingIn = state.matchedLocation == Routes.login;
  //   if (loggedIn == null || !loggedIn) {
  //     return Routes.login;
  //   }
  //   if (loggingIn) {
  //     return Routes.home;
  //   }
  //   return null;
  // },
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    // Add other routes here
  ],
);
