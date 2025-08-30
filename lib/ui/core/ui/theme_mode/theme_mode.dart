import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/ui/core/ui/theme_mode/provider/theme_mode_provider.dart';

class ThemeModeSwitcher extends ConsumerWidget {
  const ThemeModeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final iconColor = Theme.of(context).colorScheme.onBackground;

    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: IconButton(
        onPressed: () {
          ref.read(themeModeProvider.notifier).state = mode == ThemeMode.dark
              ? ThemeMode.light
              : ThemeMode.dark;
        },
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: Tween(begin: 0.75, end: 1.0).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Icon(
            mode == ThemeMode.dark ? Icons.nights_stay : Icons.wb_sunny,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
