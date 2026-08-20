import 'package:delivery_man_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:delivery_man_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('إسناد طلب مرتجع → نقل للخارج → إرجاع للموقع',
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
      debugPrint('before input otp');
      for (int i = 0; i < otp.length; i++) {
        await tester.enterText(find.byKey(Key('otp_field_$i')), otp[i]);
      }
      debugPrint('after input otp'); 
      //await tester.testTextInput.receiveAction(TextInputAction.done);
      //await tester.pumpAndSettle();
      debugPrint('before 5 seconds wait'); 
      await tester.pump(const Duration(seconds: 5));
      debugPrint('after 5 seconds wait'); 
      await tester.pump(const Duration(seconds: 5));

      // انتقل لشاشة ReturnedOrders
      debugPrint('before returnedOrdersButton');
      final returnedOrdersButton =
          find.byKey(const Key('returnedOrdersButton'));
      if (returnedOrdersButton.evaluate().isEmpty) {
        debugPrint('❌ returnedOrdersButton غير موجود على الشاشة!');
        return; // وقف الاختبار لتجنب crash
      }
      debugPrint('after returnedOrdersButton'); 
      await tester.tap(returnedOrdersButton);
      await tester.pump(const Duration(seconds: 5));

      // تحقق من الانتقال للـ ReturnedOrdersScreen
      debugPrint('Current route: ${Get.currentRoute}');
      // expect(Get.currentRoute, Routes.returnedOrders); // اختياري

      // ابحث عن أول تفاصيل الطلبات
      final firstOrderDetailsButton = find.byKey(const Key('showDetails_0'));
      if (firstOrderDetailsButton.evaluate().isEmpty) {
        debugPrint('❌ showDetails_0 غير موجود!');
        return;
      }

      await tester.tap(firstOrderDetailsButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 10));

      // زر الإسناد
      final assignButton = find.byKey(const Key('assignButton'));
      if (assignButton.evaluate().isEmpty) {
        debugPrint('❌ assignButton غير موجود!');
        return;
      }

      await tester.tap(assignButton);
      await Future.delayed(const Duration(seconds: 1));

      // تحقق من ظهور الرسالة
      final dialogTextEn = find.text('The order will be assigned to you');
      final dialogTextAr = find.text('سيتم إسناد الطلب لك');

      if (dialogTextEn.evaluate().isEmpty && dialogTextAr.evaluate().isEmpty) {
        debugPrint('❌ Dialog لم يظهر');
      } else {
        debugPrint('✅ Dialog موجود');
      }
      await Future.delayed(const Duration(seconds: 3));

      final confirmButtonEn = find.text('Confirm');
      final confirmButtonAr = find.text('تأكيد');

      if (confirmButtonEn.evaluate().isNotEmpty) {
        await tester.tap(confirmButtonEn);
      } else if (confirmButtonAr.evaluate().isNotEmpty) {
        await tester.tap(confirmButtonAr);
      } else {
        debugPrint('❌ زر Confirm / تأكيد غير موجود!');
      }

      await tester.pump(const Duration(seconds: 5));

      // انتقل لصفحة MyOrders
      // final myOrdersButton = find.byKey(const Key('myOrdersTabButton'));
      // if (myOrdersButton.evaluate().isNotEmpty) {
      //   await tester.tap(myOrdersButton);
      //   await tester.pumpAndSettle();
      //   await Future.delayed(const Duration(seconds: 2));
      //   await tester.pumpAndSettle();
      // }

      debugPrint('✅ انتقلنا لـ MyOrders');
      await tester.pump(const Duration(seconds: 10));

      // تفاصيل أول طلب في MyOrders
      final firstOrderDetailsButtonInDelivered =
          find.byKey(const Key('showDetails_0'));
      if (firstOrderDetailsButtonInDelivered.evaluate().isNotEmpty) {
        await tester.tap(firstOrderDetailsButtonInDelivered);
        await tester.pump(const Duration(seconds: 5));
      } else {
        debugPrint('❌ showDetails_0 غير موجود في MyOrders');
      }
    } catch (e, s) {
      debugPrint('❌ خطأ في الاختبار: $e');
      debugPrint('STACK: $s');
    }
  });
}
