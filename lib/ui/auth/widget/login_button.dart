import 'package:flutter/material.dart';
import 'package:weather_todo/ui/core/ui/widget/state_full_button.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.onPressed});
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 40,
        child: StateFullButton(
          icon: const Icon(Icons.login),
          label: 'Login',
          onPressed: onPressed,
        ),
      ),
    );
  }
}
