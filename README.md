# Versatile Dialogs

[![pub package](https://img.shields.io/pub/v/versatile_dialogs.svg)](https://pub.dartlang.org/packages/versatile_dialogs)
[![codecov](https://codecov.io/gh/shanmugam28/versatile_dialogs/branch/master/graph/badge.svg)](https://codecov.io/gh/shanmugam28/versatile_dialogs)
[![Build Status](https://github.com/shanmugam28/versatile_dialogs/workflows/Package%20Tests/badge.svg?branch=master)](https://github.com/shanmugam28/versatile_dialogs/actions/workflows/flutter_tests.yaml)

A versatile Flutter package that provides customizable dialogs for single and multi-value selection, including lazy loading and various customization options.

## Add Package to your flutter project

To install package go to your terminal and run

```dart
flutter pub add versatile_dialogs
```

or add `versatile_dialogs` to your _pubspec.yaml_ and run

```dart
flutter pub get
```

## Usage

### 1. Primary dialog

Initialise Primary dialog class

```dart
PrimaryDialog primaryDialog = PrimaryDialog(
  key: const Key('primaryDialog'),
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
```

Show the dialog and get the result back

```dart

bool? result = await primaryDialog.show(context);

if(result == null){
print("Tapped outside of dialog");
} else if(result){
print("Pressed OK button");
} else {
print("Pressed Cancel button");
}
```

https://github.com/shanmugam28/versatile_dialogs/assets/81793777/599ebf14-32c8-4cba-9f18-a3d31a46f9f5

### 2. Loading dialog

Initialise Loading dialog class

```dart
LoadingDialog loadingDialog = LoadingDialog(message: "Loading...");
```

Show the dialog
```dart
loadingDialog.show(context);
```

dismiss the dialog
```dart
loadingDialog.dismiss(context);
```

https://github.com/shanmugam28/versatile_dialogs/assets/81793777/624d9992-1d57-4ead-b4ff-3ea2b511c313

### 3. Single value picker dialog

Initialise Single value picker dialog class

```dart
SingleValuePickerDialog<String> singleValuePickerDialog = SingleValuePickerDialog(
  items: ['one', 'two', 'three', 'four', 'five', 'six'],
  title: 'Pick a value',
  itemBuilder: (context, value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(value),
    );
  },
  dialogButton: DialogButton(
    context: context,
    negativeButtonKey: const Key('negativeButton'),
    negativeButtonName: 'Cancel',
  ),
);
```

Show the dialog and get the picked item

```dart
String? result = await singleValuePickerDialog.show(context);

if(result != null){
  print("No value picked");
} else {
  print("Picked Item -> $result");
}
```

https://github.com/shanmugam28/versatile_dialogs/assets/81793777/cf4f77d4-0b4e-4c7c-97a2-09e8a62433ce

### 4. Multi value picker dialog

Initialise Multi value picker dialog class

```dart
MultiValuePickerDialog<String> multiSelectableDialog = MultiValuePickerDialog(
  title: 'Pick values',
  items: ['one', 'two', 'three', 'four', 'five', 'six'],
  initialSelectedItems: ['three'],
  itemBuilder: (context, value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(value),
    );
  },
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
```

Show the dialog and get the picked items

```dart
List<String> result = await multiSelectableDialog.show(context) ?? [];

if(result.isEmpty){
  print("No value picked");
} else {
  print("Picked Items -> $result");
}
```

https://github.com/shanmugam28/versatile_dialogs/assets/81793777/1c5e0f4c-836a-40d5-b103-fd128ca50abb

### 5. Lazy single value picker dialog

Initialise Lazy single value picker dialog class.
Add future list of items which can be loaded and shown in the dialog to pick a value

```dart
LazySingleValuePickerDialog<String> dialog = LazySingleValuePickerDialog(
  asyncItems: getAsyncItems,
  itemBuilder: (context, value) =>
      Padding(
        key: Key(value),
        padding: const EdgeInsets.all(8.0),
        child: Text(value),
      ),
  title: 'Pick a value',
  loadingMessage: "Fetching data...",
  dialogButton: DialogButton(
    context: context,
    negativeButtonName: 'Cancel',
  ),
);

Future<List<String>> getAsyncItems() async {
  await Future.delayed(const Duration(seconds: 2));
  return ['one', 'two', 'three', 'four', 'five', 'six'];
}
```

Show the dialog and get the picked item

```dart
String? item = await dialog.show(context);

if(item != null){
print("No value picked");
} else {
print("Picked Item -> $item");
}
```

https://github.com/shanmugam28/versatile_dialogs/assets/81793777/8817844b-ece4-44af-8d8b-1e9599a3d8c9

### 6. Lazy multi value picker dialog

Initialise Lazy multi value picker dialog class.
Add future list of items which can be loaded and shown in the dialog to pick a value

```dart
MultiValuePickerDialog<String> multiSelectableDialog = MultiValuePickerDialog(
  title: 'Pick values',
  asyncItems: getAsyncItems,
  initialSelectedItems: ['three'],
  itemBuilder: (context, value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(value),
    );
  },
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

Future<List<String>> getAsyncItems() async {
  await Future.delayed(const Duration(seconds: 2));
  return ['one', 'two', 'three', 'four', 'five', 'six'];
}
```

Show the dialog and get the picked items

```dart
List<String> result = await multiSelectableDialog.show(context) ?? [];

if(result.isEmpty){
  print("No value picked");
} else {
  print("Picked Items -> $result");
}
```

https://github.com/shanmugam28/versatile_dialogs/assets/81793777/72ce9d3e-9663-416d-8097-90c17b43a769
