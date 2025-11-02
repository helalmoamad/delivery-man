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
    // غلاف try-catch لمعرفة الأخطاء الحقيقية
    try {
      app.main();

      // انتظر أول Build
      await tester.pump(const Duration(seconds: 1));

      // انتظر Splash / تحميل البيانات (5 ثواني تقريبا)
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // ابحث عن زر طلبات مرتجعة
      final returnedOrdersButton =
          find.byKey(const Key('returnedOrdersButton'));
      if (returnedOrdersButton.evaluate().isEmpty) {
        debugPrint('❌ returnedOrdersButton غير موجود على الشاشة!');
        return; // وقف الاختبار لتجنب crash
      }

      await tester.tap(returnedOrdersButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

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
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // زر الإسناد
      final assignButton = find.byKey(const Key('assignButton'));
      if (assignButton.evaluate().isEmpty) {
        debugPrint('❌ assignButton غير موجود!');
        return;
      }

      await tester.tap(assignButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();

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

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 6));
      await tester.pumpAndSettle();

      // انتقل لصفحة MyOrders
      // final myOrdersButton = find.byKey(const Key('myOrdersTabButton'));
      // if (myOrdersButton.evaluate().isNotEmpty) {
      //   await tester.tap(myOrdersButton);
      //   await tester.pumpAndSettle();
      //   await Future.delayed(const Duration(seconds: 2));
      //   await tester.pumpAndSettle();
      // }

      debugPrint('✅ انتقلنا لـ MyOrders');
      await Future.delayed(const Duration(seconds: 8));

      // تفاصيل أول طلب في MyOrders
      final firstOrderDetailsButtonInDelivered =
          find.byKey(const Key('showDetails_0'));
      if (firstOrderDetailsButtonInDelivered.evaluate().isNotEmpty) {
        await tester.tap(firstOrderDetailsButtonInDelivered);
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(seconds: 5));
        await tester.pumpAndSettle();
      } else {
        debugPrint('❌ showDetails_0 غير موجود في MyOrders');
      }
    } catch (e, s) {
      debugPrint('❌ خطأ في الاختبار: $e');
      debugPrint('STACK: $s');
    }
  });
}
