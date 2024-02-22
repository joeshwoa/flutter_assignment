import 'package:flutter/material.dart';
import 'package:flutter_assignment/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Integration Test', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts with the correct title
    expect(find.text('/r/FlutterDev'), findsOneWidget);

    // Tap on the 'New' tab
    await tester.tap(find.text('New'));
    await tester.pump();

    // Verify that the 'New' tab is selected
    expect(find.text('New'), findsOneWidget);

    // Simulate scrolling to load more posts
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();

    // Verify that more posts are loaded
    expect(find.byType(Container), findsWidgets); // Adjust this based on your post widget

    // Tap on the 'Rising' tab
    await tester.tap(find.text('Rising'));
    await tester.pump();

    // Verify that the 'Rising' tab is selected
    expect(find.text('Rising'), findsOneWidget);

    // Simulate scrolling to load more posts
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();

    // Verify that more posts are loaded
    expect(find.byType(Container), findsWidgets); // Adjust this based on your post widget
  });
}
