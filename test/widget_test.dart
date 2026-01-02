import 'package:flutter_test/flutter_test.dart';

import 'package:fridge_food_list/main.dart';

void main() {
  testWidgets('App displays fridge sections', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(FridgeApp());

    // Verify that the app title is displayed.
    expect(find.text('冰箱食材列表'), findsOneWidget);

    // Verify that the sections are displayed.
    expect(find.text('冷冻层'), findsOneWidget);
    expect(find.text('冷藏层'), findsOneWidget);

    // Verify that the quantities are displayed.
    expect(find.text('500g'), findsOneWidget);
    expect(find.text('2个'), findsOneWidget);

    // Verify that the icons are displayed.
    expect(find.text('🥩'), findsOneWidget);
    expect(find.text('🥚'), findsOneWidget);
  });
}
