import 'package:flutter/material.dart';
import 'package:versatile_dialogs/common/dialog_buttons.dart';
import 'package:versatile_dialogs/common/multi_dialog_selection_type.dart';
import 'package:versatile_dialogs/lazy_multi_value_picker_dialog.dart';
import 'package:versatile_dialogs/lazy_single_value_picker_dialog.dart';
import 'package:versatile_dialogs/loading_dialog.dart';
import 'package:versatile_dialogs/multi_value_picker_dialog.dart';
import 'package:versatile_dialogs/primary_dialog.dart';
import 'package:versatile_dialogs/single_value_picker_dialog.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dialogs testing Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> list = [
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten',
    'eleven',
    'twelve',
  ];

  Future<List<String>> getAsyncItems() async {
    await Future.delayed(const Duration(seconds: 3));
    return [
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'ten',
      'eleven',
      'twelve',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Dialog testing page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              key: const Key('primaryDialogButton'),
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: _showPrimaryDialog,
                child: const Text(
                  'Primary dialog',
                ),
              ),
            ),
            Padding(
              key: const Key('loadingDialogButton'),
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: _showLoadingDialog,
                child: const Text(
                  'Loading dialog',
                ),
              ),
            ),
            Padding(
              key: const Key('singleValuePickerDialogButton'),
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: _showSingleValuePickerDialog,
                child: const Text(
                  'Single value picker dialog',
                ),
              ),
            ),
            Padding(
              key: const Key('multiValuePickerDialogButton'),
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: _showMultiValuePickerDialog,
                child: const Text(
                  'Multi value picker dialog',
                ),
              ),
            ),
            Padding(
              key: const Key('lazySingleValuePickerDialogButton'),
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: _showLazySingleValuePickerDialog,
                child: const Text(
                  'Lazy single value picker dialog',
                ),
              ),
            ),
            Padding(
              key: const Key('lazyMultiValuePickerDialogButton'),
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: _showLazyMultiValuePickerDialog,
                child: const Text(
                  'Lazy multi value picker dialog',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrimaryDialog() async {
    PrimaryDialog primaryDialog = PrimaryDialog(
      key: const Key('primaryDialog'),
      title: 'Primary dialog',
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Text('This is a description for primary dialog'),
      ),
      dialogButton: DialogButton(
        context: context,
        positiveButtonWidget: _getPositiveButtonWidget(
          const Key('positiveButton'),
          "OK",
        ),
        negativeButtonWidget: _getNegativeButtonWidget(
          const Key('negativeButton'),
          "Cancel",
        ),
      ),
    );
    bool? result = await primaryDialog.show(context);

    if (context.mounted) {
      SnackBar snackBar = SnackBar(
        content: Center(
          child: Text(
            result == null
                ? 'Tapped outside of dialog'
                : result
                    ? 'Pressed OK button'
                    : 'Pressed Cancel button',
          ),
        ),
        behavior: SnackBarBehavior.floating,
      );

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(snackBar);
    }
  }

  void _showLoadingDialog() async {
    LoadingDialog loadingDialog = LoadingDialog(message: "Loading...")
      ..show(context);

    Future.delayed(const Duration(seconds: 3)).then((value) {
      loadingDialog.dismiss(context);
      if (context.mounted) {
        SnackBar snackBar = const SnackBar(
          content: Center(
            child: Text("Dialog loaded for 3 seconds"),
          ),
          behavior: SnackBarBehavior.floating,
        );

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(snackBar);
      }
    });
  }

  void _showSingleValuePickerDialog() async {
    SingleValuePickerDialog<String> singleValuePickerDialog =
        SingleValuePickerDialog(
      items: list,
      title: 'Pick a value',
      itemBuilder: (context, value) {
        return Padding(
          key: Key(value),
          padding: const EdgeInsets.all(17.0),
          child: Text(value),
        );
      },
      dialogButton: DialogButton(
        context: context,
        negativeButtonWidget: _getNegativeButtonWidget(
          const Key('negativeButton'),
          "Cancel",
        ),
      ),
    );

    String? result = await singleValuePickerDialog.show(context);

    if (context.mounted) {
      SnackBar snackBar = SnackBar(
        content: Center(
          child: Text(
            result != null ? "'$result' picked" : "No value picked",
          ),
        ),
        behavior: SnackBarBehavior.floating,
      );

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(snackBar);
    }
  }

  void _showMultiValuePickerDialog() async {
    MultiValuePickerDialog<String> multiSelectableDialog =
        MultiValuePickerDialog(
      title: 'Pick values',
      items: list,
      initialSelectedItems: ['three', 'five'],
      itemBuilder: (context, value) {
        return Padding(
          key: Key('disabled$value'),
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        );
      },
      selectionType: MultiDialogSelectionType.itemTap,
      selectedItemBuilder: (context, value) {
        return Padding(
          key: Key('enabled$value'),
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: const TextStyle(color: Colors.deepPurple),
          ),
        );
      },
      dialogButton: DialogButton(
        context: context,
        positiveButtonWidget: _getPositiveButtonWidget(
          const Key('positiveButton'),
          "Pick",
        ),
        negativeButtonWidget: _getNegativeButtonWidget(
          const Key('negativeButton'),
          "Cancel",
        ),
      ),
    );

    List<String> result = await multiSelectableDialog.show(context) ?? [];

    if (context.mounted) {
      SnackBar snackBar = SnackBar(
        content: Center(
          child: Text(result.isNotEmpty
              ? "'${result.join(', ')}' picked"
              : "No value picked"),
        ),
        behavior: SnackBarBehavior.floating,
      );

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(snackBar);
    }
  }

  void _showLazySingleValuePickerDialog() async {
    LazySingleValuePickerDialog<String> dialog = LazySingleValuePickerDialog(
      asyncItems: getAsyncItems,
      itemBuilder: (context, value) => Padding(
        key: Key(value),
        padding: const EdgeInsets.all(8.0),
        child: Text(value),
      ),
      title: 'Pick a value',
      dialogButton: DialogButton(
        context: context,
        negativeButtonWidget: _getNegativeButtonWidget(
          const Key('negativeButton'),
          "Cancel",
        ),
      ),
    );

    String? item = await dialog.show(context);

    if (context.mounted) {
      SnackBar snackBar = SnackBar(
        content: Center(
          child: Text(item != null ? "'$item' picked" : "No value picked"),
        ),
        behavior: SnackBarBehavior.floating,
      );

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(snackBar);
    }
  }

  void _showLazyMultiValuePickerDialog() async {
    LazyMultiValuePickerDialog<String> dialog = LazyMultiValuePickerDialog(
      asyncItems: getAsyncItems,
      initialSelectedItems: ['three', 'five'],
      itemBuilder: (context, value) => Padding(
        key: Key(value),
        padding: const EdgeInsets.all(8.0),
        child: Text(value),
      ),
      title: 'Pick values',
      dialogButton: DialogButton(
        context: context,
        positiveButtonKey: const Key('positiveButton'),
        negativeButtonKey: const Key('negativeButton'),
        positiveButtonName: 'Pick',
        negativeButtonName: 'Cancel',
      ),
    );

    List<String> items = await dialog.show(context) ?? [];

    if (context.mounted) {
      SnackBar snackBar = SnackBar(
        content: Center(
          child: Text(items.isNotEmpty
              ? "'${items.join(', ')}' picked"
              : "No value picked"),
        ),
        behavior: SnackBarBehavior.floating,
      );

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(snackBar);
    }
  }

  _getPositiveButtonWidget(Key key, String text) => Container(
        key: key,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 20.0,
        ),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
        ),
      );

  _getNegativeButtonWidget(Key key, String text) => Container(
        key: key,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 20.0,
        ),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      );
}
