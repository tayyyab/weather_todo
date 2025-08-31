import 'package:go_router/go_router.dart';
import 'package:weather_todo/routing/routes.dart';
import 'package:weather_todo/ui/auth/provider/auth_state_provider.dart';
import 'package:weather_todo/ui/auth/widget/login_screen.dart';
import 'package:weather_todo/ui/home/widget/home_screen.dart';

GoRouter router(AuthState authState) => GoRouter(
  initialLocation: Routes.login,
  redirect: (context, state) async {
    final loggedIn = authState.isAuthenticated;
    final loggingIn = state.matchedLocation == Routes.login;

    if (loggingIn && !loggingIn) {
      return null;
    }

    if (loggingIn && loggedIn) {
      return Routes.home;
    } else if (!loggedIn) {
      return Routes.login;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    // Add other routes here
    GoRoute(path: Routes.home, builder: (context, state) => const HomeScreen()),
  ],
);
