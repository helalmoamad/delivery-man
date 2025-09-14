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
    app.main();
    await tester.pumpAndSettle();

    //// click on returned orders
    final returnedOrdersButton = find.byKey(const Key('returnedOrdersButton'));
    expect(returnedOrdersButton, findsOneWidget);

    await tester.tap(returnedOrdersButton);
    await tester.pumpAndSettle();

    // check of move to returnedOrders
    expect(Get.currentRoute, Routes.returnedOrders);

    // find the first details of returned orders 
    final firstOrderDetailsButton =
        find.byKey(const Key('orderDetailsButton_0'));
    expect(firstOrderDetailsButton, findsOneWidget);

    // click on orderDetailsButton_0
    await tester.tap(firstOrderDetailsButton);
    await tester.pumpAndSettle();

    // check of move to ordersDetailsPage
    expect(Get.currentRoute, Routes.ordersDetailsPage);

    // click on assignButton
    final assignButton = find.byKey(const Key('assignButton'));
    expect(assignButton, findsOneWidget);
    await tester.tap(assignButton);
    await tester.pumpAndSettle();

    // check if dialog appeared xxxxxxxxxxxxx
    expect(find.text('The order  will be assigned to you'), findsOneWidget);

    // click on Confirm
    final confirmButton = find.text('Confirm');
    expect(confirmButton, findsOneWidget);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    final myOrdersButton = find.byKey(const Key('myOrdersTabButton'));
    await tester.tap(myOrdersButton);
    await tester.pumpAndSettle();

    // check if moved to MyOrders
    expect(find.text('MyOrders'), findsOneWidget);

    // find and click deliveredTab
    final deliveredTab = find.byKey(const Key('orderStatus_delivered'));
    await tester.tap(deliveredTab);
    await tester.pumpAndSettle();

    // find the first details of returned orders 
    final firstOrderDetailsButtonInDelivered =
        find.byKey(const Key('orderDetailsButton_0'));
    expect(firstOrderDetailsButtonInDelivered, findsOneWidget);

    await tester.tap(firstOrderDetailsButtonInDelivered);
    await tester.pumpAndSettle();
  });
}
