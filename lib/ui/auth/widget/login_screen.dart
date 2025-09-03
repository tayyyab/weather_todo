import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_todo/ui/auth/provider/login_provider.dart';
import 'package:weather_todo/ui/auth/view_model/login_view_model.dart';
import 'package:weather_todo/ui/auth/widget/login_button.dart';
import 'package:weather_todo/ui/auth/widget/password_text_field.dart';
import 'package:weather_todo/ui/auth/widget/username_text_field.dart';
import 'package:weather_todo/ui/core/ui/theme_mode/theme_mode.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  _login(BuildContext context, LoginViewModel viewModel) async {
    FocusScope.of(context).unfocus();
    final result = await viewModel.login();
    result.when(
      success: (data) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login Successful')));
        }
      },
      failure: (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Login Failed: $error')));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewModel = ref.watch(loginViewModelProvider);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [ThemeModeSwitcher()],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  'Welcome to Weather ToDo',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 100),
                    Text(
                      'Login ',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    UsernameTextField(
                      key: const ValueKey('username_field'),
                      onChanged: (value) {
                        viewModel.updateUsername(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    PasswordTextField(
                      key: const ValueKey('password_field'),
                      onChanged: (value) {
                        viewModel.updatePassword(value);
                      },
                    ),

                    const SizedBox(height: 16),
                    LoginButton(
                      onPressed: () async => _login(context, viewModel),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
