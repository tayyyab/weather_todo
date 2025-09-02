import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_todo/ui/auth/widget/login_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  group('Login Feature', () {
    late final app;
    setUpAll(() async {
      app = const ProviderScope(child: MaterialApp(home: LoginScreen()));
    });
    testWidgets('Login with valid credentials', (WidgetTester tester) async {
      await tester.pumpWidget(app);

      await tester.enterText(
        find.byKey(const ValueKey('username_field')),
        'test',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password_field')),
        '1234',
      );

      var button = find.byKey(const ValueKey('login_button'));
      expect(button, isNotNull);
      await tester.tap(button, warnIfMissed: true);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Login Successful'), findsOneWidget);
    });

    testWidgets('Login with in-valid credentials', (WidgetTester tester) async {
      await tester.pumpWidget(app);

      await tester.enterText(
        find.byKey(const ValueKey('username_field')),
        'test2',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password_field')),
        '12342',
      );

      var button = find.byKey(const ValueKey('login_button'));
      expect(button, isNotNull);
      await tester.tap(button, warnIfMissed: true);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(
        find.text('Login Failed: Invalid username or password'),
        findsOneWidget,
      );
    });
  });
}
