import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/ui/core/ui/theme_mode/provider/theme_mode_provider.dart';

class ThemeModeSwitcher extends ConsumerWidget {
  const ThemeModeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);

    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: IconButton(
        onPressed: () {
          // Add haptic feedback for better UX
          ref.read(themeModeProvider.notifier).state = mode == ThemeMode.dark
              ? ThemeMode.light
              : ThemeMode.dark;
        },
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: Tween(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
              child: FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
            );
          },
          child: Icon(
            key: ValueKey<ThemeMode>(mode),
            mode == ThemeMode.dark ? Icons.nights_stay : Icons.wb_sunny,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
