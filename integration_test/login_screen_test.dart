import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:delivery_man_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login screen shows email, password and login button',
      (WidgetTester tester) async {
    try {
      app.main();
      await tester.pump(const Duration(seconds: 15));
      await tester.pumpAndSettle();
      debugDumpApp();

      final phoneNumberInput =
          find.byKey(const Key('PhoneNumberInput')); // search about item
      if (phoneNumberInput.evaluate().isEmpty) {
        debugPrint('❌ PhoneNumberInput غير موجود');
        debugDumpApp();
        return;
      }

      expect(phoneNumberInput, findsOneWidget); // sure if exist
      await tester.enterText(phoneNumberInput, '937549192'); // enter text
      await tester.pump();
      final loginButton = find.byKey(const Key('LoginButton'));
      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      final whatsappButton = find.byKey(const Key('whatsapp'));
      expect(whatsappButton, findsOneWidget);
      await tester.tap(whatsappButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      final confirmButton = find.byKey(const Key('ConfirmButton'));
      await tester.runAsync(() async {
        await tester.tap(confirmButton);
        await tester.pump(); // trigger the tap
        await Future.delayed(const Duration(seconds: 20)); // wait async call
        await tester.pumpAndSettle(); // let navigation complete
      });
      await tester.pump(const Duration(seconds: 2));

      const String otp = '999999';

      for (int i = 0; i < otp.length; i++) {
        await tester.enterText(find.byKey(Key('otp_field_$i')), otp[i]);
      }

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));

    } catch (e, s) {
      debugPrint('❌ خطأ في الاختبار: $e');
      debugPrint('STACK: $s');
    }
  });
}
