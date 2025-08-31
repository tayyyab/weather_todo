import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_todo/routing/router.dart';
import 'package:weather_todo/ui/auth/provider/auth_state_provider.dart';
import 'package:weather_todo/ui/core/ui/theme_mode/provider/theme_mode_provider.dart';
import 'package:weather_todo/ui/core/theme/theme.dart';
import 'package:weather_todo/ui/core/theme/utils.dart';

void main() async {
  init();
  runApp(const ProviderScope(child: MyApp()));
}

init() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Hive.init('./');
  var path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = createTextTheme(context, "Roboto", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);
    var mode = ref.watch(themeModeProvider);

    var authState = ref.watch(authStateProvider);

    return MaterialApp.router(
      title: 'Weather ToDo Demo',
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: mode,
      routerConfig: router(authState),
    );
  }
}
