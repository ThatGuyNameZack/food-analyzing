import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_detection_protein/main.dart'; // Import your main.dart file

void main() {
  testWidgets('Test if the Food Recognition app UI works correctly', (WidgetTester tester) async {
    // Build the widget and trigger a frame
    await tester.pumpWidget(MyApp());

    // Verify if the app bar title is correct
    expect(find.text('Food Recognition'), findsOneWidget);

    // Verify if the 'Pick Image' button (FloatingActionButton) is present
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Verify if the loading indicator is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simulate a button press to pick an image
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // Rebuild the widget after the action

    // Verify that the alert button (MyAlert) is shown
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Test image classification output', (WidgetTester tester) async {
    // Mock classification output (you can mock the API responses and output here)
    // Make sure the result is displayed correctly in the widget
    await tester.pumpWidget(MyApp());

    // Simulate the result of image classification
    // Assume an image is picked and classified here

    // Verify if the classification result is displayed
    expect(find.text('Calories'), findsOneWidget); // Example of nutritional info
    expect(find.text('Protein'), findsOneWidget);
    expect(find.text('Fat'), findsOneWidget);
  });
}
