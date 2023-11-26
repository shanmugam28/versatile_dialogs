import 'package:flutter/material.dart';
import 'package:versatile_dialogs/common/dialog_buttons.dart';
import 'package:versatile_dialogs/lazy_multi_value_picker_dialog.dart';
import 'package:versatile_dialogs/lazy_single_value_picker_dialog.dart';
import 'package:versatile_dialogs/loading_dialog.dart';
import 'package:versatile_dialogs/multi_value_picker_dialog.dart';
import 'package:versatile_dialogs/primary_dialog.dart';
import 'package:versatile_dialogs/single_value_picker_dialog.dart';

void main() {
  runApp(const MyApp());
}

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
      home: const VersatileDialogsExample(),
    );
  }
}

class VersatileDialogsExample extends StatefulWidget {
  const VersatileDialogsExample({super.key});

  @override
  State<VersatileDialogsExample> createState() =>
      _VersatileDialogsExampleState();
}

class _VersatileDialogsExampleState extends State<VersatileDialogsExample> {
  List<String> list = ['one', 'two', 'three', 'four', 'five', 'six'];

  Future<List<String>> getAsyncItems() async {
    await Future.delayed(const Duration(seconds: 2));
    return ['one', 'two', 'three', 'four', 'five', 'six'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Versatile dialogs example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: _showPrimaryDialog,
                child: const Text(
                  'Primary dialog',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: _showLoadingDialog,
                child: const Text(
                  'Loading dialog',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: _showSingleValuePickerDialog,
                child: const Text(
                  'Single value picker dialog',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: _showMultiValuePickerDialog,
                child: const Text(
                  'Multi value picker dialog',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: _showLazySingleValuePickerDialog,
                child: const Text(
                  'Lazy single value picker dialog',
                ),
              ),
            ),
            Padding(
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
      title: 'Primary dialog',
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Text('This is a description for primary dialog'),
      ),
      dialogButton: DialogButton(
        context: context,
        positiveButtonName: "OK",
        negativeButtonName: "Cancel",
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
          padding: const EdgeInsets.all(17.0),
          child: Text(value),
        );
      },
      dialogButton: DialogButton(
        context: context,
        negativeButtonName: 'Cancel',
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
      initialSelectedItems: ['three'],
      itemBuilder: (context, value) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        );
      },
      // selectionType: MultiDialogSelectionType.itemTap,
      selectedItemBuilder: (context, value) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: const TextStyle(color: Colors.deepPurple),
          ),
        );
      },
      dialogButton: DialogButton(
        context: context,
        positiveButtonName: 'Pick',
        negativeButtonName: 'Cancel',
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
        padding: const EdgeInsets.all(8.0),
        child: Text(value),
      ),
      loadingMessage: "Fetching data...",
      title: 'Pick a value',
      dialogButton: DialogButton(
        context: context,
        negativeButtonName: 'Cancel',
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
      initialSelectedItems: ['three'],
      itemBuilder: (context, value) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value),
      ),
      title: 'Pick values',
      dialogButton: DialogButton(
        context: context,
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
}
