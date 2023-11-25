import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_page.dart';

void main() {
  group('Primary dialog', () {
    testWidgets(
      'OK button',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final primaryDialogButton =
            find.byKey(const ValueKey('primaryDialogButton'));
        await widgetTester.tap(primaryDialogButton);
        await widgetTester.pump();
        final positiveButton = find.byKey(const ValueKey('positiveButton'));
        await widgetTester.tap(positiveButton);
        await widgetTester.pump();
        expect(find.text("Pressed OK button"), findsOneWidget);
      },
    );

    testWidgets(
      'Cancel button',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final primaryDialogButton =
            find.byKey(const ValueKey('primaryDialogButton'));
        await widgetTester.tap(primaryDialogButton);
        await widgetTester.pump();
        final negativeButton = find.byKey(const ValueKey('negativeButton'));
        await widgetTester.tap(negativeButton);
        await widgetTester.pump();
        expect(find.text("Pressed Cancel button"), findsOneWidget);
      },
    );
  });

  group('Custom primary dialog', () {
    testWidgets(
      'OK button',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final primaryDialogButton =
            find.byKey(const ValueKey('customPrimaryDialogButton'));
        await widgetTester.tap(primaryDialogButton);
        await widgetTester.pump();
        final negativeButton = find.byKey(const ValueKey('negativeButton'));
        await widgetTester.tap(negativeButton);
        await widgetTester.pump();
        expect(find.text("Pressed Cancel button"), findsOneWidget);
      },
    );
  });

  group('Loading dialog', () {
    testWidgets(
      'Load for 3 seconds',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final loadingDialogButton =
            find.byKey(const ValueKey('loadingDialogButton'));
        await widgetTester.tap(loadingDialogButton);
        await widgetTester.pump();
        await widgetTester.pump(const Duration(milliseconds: 3500));
        expect(find.text("Dialog loaded for 3 seconds"), findsOneWidget);
      },
    );
  });

  group('Custom loading dialog', () {
    testWidgets(
      'Load for 3 seconds',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final loadingDialogButton =
            find.byKey(const ValueKey('customLoadingDialogButton'));
        await widgetTester.tap(loadingDialogButton);
        await widgetTester.pump();
        await widgetTester.pump(const Duration(milliseconds: 3500));
        expect(find.text("Dialog loaded for 3 seconds"), findsOneWidget);
      },
    );
  });

  group('Single value picker dialog', () {
    testWidgets(
      'Pick a value at 0th index',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final singleValuePickerDialogButton =
            find.byKey(const ValueKey('singleValuePickerDialogButton'));
        await widgetTester.tap(singleValuePickerDialogButton);
        await widgetTester.pump();
        final item = find.byKey(const ValueKey('one'));
        await widgetTester.tap(item);
        await widgetTester.pump();
        expect(find.text("'one' picked"), findsOneWidget);
      },
    );

    testWidgets(
      'Pick a value at 5th index',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final singleValuePickerDialogButton =
            find.byKey(const ValueKey('singleValuePickerDialogButton'));
        await widgetTester.tap(singleValuePickerDialogButton);
        await widgetTester.pump();
        final item = find.byKey(const ValueKey('six'));
        await widgetTester.tap(item);
        await widgetTester.pump();
        expect(find.text("'six' picked"), findsOneWidget);
      },
    );

    testWidgets(
      'Pick nothing button',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final singleValuePickerDialogButton =
            find.byKey(const ValueKey('singleValuePickerDialogButton'));
        await widgetTester.tap(singleValuePickerDialogButton);
        await widgetTester.pump();
        final negativeButton = find.byKey(const ValueKey('positiveButton'));
        await widgetTester.tap(negativeButton);
        await widgetTester.pump();
        expect(find.text("No value picked"), findsOneWidget);
      },
    );

    testWidgets(
      'Cancel button',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final singleValuePickerDialogButton =
            find.byKey(const ValueKey('singleValuePickerDialogButton'));
        await widgetTester.tap(singleValuePickerDialogButton);
        await widgetTester.pump();
        final negativeButton = find.byKey(const ValueKey('negativeButton'));
        await widgetTester.tap(negativeButton);
        await widgetTester.pump();
        expect(find.text("No value picked"), findsOneWidget);
      },
    );
  });

  group('Multi value picker dialog', () {
    testWidgets(
      'Pick values at 3rd and 5th index',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final multiValuePickerDialogButton =
            find.byKey(const ValueKey('multiValuePickerDialogButton'));
        await widgetTester.tap(multiValuePickerDialogButton);
        await widgetTester.pump();
        final positiveButton = find.byKey(const ValueKey('positiveButton'));
        await widgetTester.tap(positiveButton);
        await widgetTester.pump();
        expect(find.text("'three, five' picked"), findsOneWidget);
      },
    );

    testWidgets(
      'Cancel button',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final multiValuePickerDialogButton =
            find.byKey(const ValueKey('multiValuePickerDialogButton'));
        await widgetTester.tap(multiValuePickerDialogButton);
        await widgetTester.pump();
        final negativeButton = find.byKey(const ValueKey('negativeButton'));
        await widgetTester.tap(negativeButton);
        await widgetTester.pump();
        expect(find.text("No value picked"), findsOneWidget);
      },
    );
  });

  group('Lazy single value picker dialog', () {
    testWidgets(
      'Pick a value at 0th index',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final lazySingleValuePickerDialogButton =
            find.byKey(const ValueKey('lazySingleValuePickerDialogButton'));
        await widgetTester.tap(lazySingleValuePickerDialogButton);
        await widgetTester.pump(const Duration(milliseconds: 3500));
        final item = find.byKey(const ValueKey('one'));
        await widgetTester.tap(item);
        await widgetTester.pump();
        expect(find.text("'one' picked"), findsOneWidget);
      },
    );

    testWidgets(
      'Pick a value at 5th index',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final lazySingleValuePickerDialogButton =
            find.byKey(const ValueKey('lazySingleValuePickerDialogButton'));
        await widgetTester.tap(lazySingleValuePickerDialogButton);
        await widgetTester.pump(const Duration(milliseconds: 3500));
        final item = find.byKey(const ValueKey('six'));
        await widgetTester.tap(item);
        await widgetTester.pump();
        expect(find.text("'six' picked"), findsOneWidget);
      },
    );

    testWidgets(
      'Cancel button',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final lazySingleValuePickerDialogButton =
            find.byKey(const ValueKey('lazySingleValuePickerDialogButton'));
        await widgetTester.tap(lazySingleValuePickerDialogButton);
        await widgetTester.pump(const Duration(milliseconds: 3500));
        final negativeButton = find.byKey(const ValueKey('negativeButton'));
        await widgetTester.tap(negativeButton);
        await widgetTester.pump();
        expect(find.text("No value picked"), findsOneWidget);
      },
    );
  });

  group('Lazy multi value picker dialog', () {
    testWidgets(
      'Pick values at 3rd and 5th index',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final lazyMultiValuePickerDialogButton =
            find.byKey(const ValueKey('lazyMultiValuePickerDialogButton'));
        await widgetTester.tap(lazyMultiValuePickerDialogButton);
        await widgetTester.pump(const Duration(milliseconds: 3500));
        final positiveButton = find.byKey(const ValueKey('positiveButton'));
        await widgetTester.tap(positiveButton);
        await widgetTester.pump();
        expect(find.text("'three, five' picked"), findsOneWidget);
      },
    );

    testWidgets(
      'Cancel button',
      (widgetTester) async {
        await widgetTester.pumpWidget(const MyApp());
        final lazyMultiValuePickerDialogButton =
            find.byKey(const ValueKey('lazyMultiValuePickerDialogButton'));
        await widgetTester.tap(lazyMultiValuePickerDialogButton);
        await widgetTester.pump(const Duration(milliseconds: 3500));
        final negativeButton = find.byKey(const ValueKey('negativeButton'));
        await widgetTester.tap(negativeButton);
        await widgetTester.pump();
        expect(find.text("No value picked"), findsOneWidget);
      },
    );
  });
}
