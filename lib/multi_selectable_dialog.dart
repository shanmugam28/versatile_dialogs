import 'package:flutter/material.dart';

import 'dialog_buttons.dart';

/// Defines the type of selection behavior in the [MultiSelectableDialog].
///
/// The [SelectionType] enum is used to specify how items in the [MultiSelectableDialog]
/// should be selected by users. It has two possible values:
///
/// - [checkboxTap]: Users can select items by tapping on checkboxes.
/// - [itemTap]: Users can select items by tapping directly on the items themselves.
///
/// Example:
/// ```dart
/// SelectionType selectionType = SelectionType.checkboxTap;
/// ```
enum SelectionType {
  /// Users can select items by tapping on checkboxes.
  checkboxTap,

  /// Users can select items by tapping directly on the items themselves.
  itemTap,
}

/// An interactive dialog that allows users to select multiple items from a list.
class MultiSelectableDialog<T> {
  /// The title of the dialog, displayed at the top.
  final String title;

  /// (Optional) Custom widget for the title. If provided, it overrides the [title].
  final Widget? titleWidget;

  /// (Optional) Style for the title text.
  final TextStyle? titleStyle;

  /// (Optional) Background color for the title bar.
  final Color? titleBackgroundColor;

  /// The list of items to be displayed in the dialog.
  final List<T> items;

  /// A callback function that defines how each item should be displayed in the list.
  final Widget Function(BuildContext context, T value) itemBuilder;

  /// (Optional) A callback function that defines how selected items should be displayed differently.
  final Widget Function(BuildContext context, T value)? selectedItemBuilder;

  /// (Optional) The initially selected items in the dialog.
  final List<T>? initialSelectedItems;

  /// Configuration for the dialog buttons (positive and negative buttons).
  final DialogButton? dialogButton;

  /// If true, initially selects all items when the dialog is opened.
  final bool initiallyMultiSelectAllItems;

  /// The type of selection behavior in the dialog.
  final SelectionType selectionType;

  /// The elevation of the dialog.
  final double elevation;

  /// (Optional) The width of the dialog. If not provided, defaults to 85% of the screen width.
  final double? dialogWidth;

  /// (Optional) The height of the dialog. If not provided, defaults to 85% of the screen height.
  final double? dialogHeight;

  /// The height of the title bar.
  final double titleHeight;

  /// The border radius of the dialog.
  final double dialogBorderRadius;

  /// If true, displays a widget showing the number of selected items.
  final bool showSelectedTextWidget;

  /// (Optional) Style for the text displaying the number of selected items.
  final TextStyle? selectedTextStyle;

  /// (Optional) Callback function to customize the text displaying the number of selected items.
  final Widget Function(List<T>? value)? selectedTextBuilder;

  /// Creates a [MultiSelectableDialog] instance with the specified parameters.
  ///
  /// This constructor allows you to create a new [MultiSelectableDialog] instance with
  /// the required and optional parameters. You can customize the appearance and behavior
  /// of the dialog by providing values for [title], [titleWidget], [titleStyle],
  /// [titleBackgroundColor], [items], [itemBuilder], [selectedItemBuilder], [initialSelectedItems],
  /// [dialogButton], [initiallyMultiSelectAllItems], [selectionType], [elevation], [dialogWidth],
  /// [dialogHeight], [titleHeight], [dialogBorderRadius], [showSelectedTextWidget],
  /// [selectedTextStyle], and [selectedTextBuilder].
  ///
  /// Example:
  /// ```dart
  /// var multiSelectableDialog = MultiSelectableDialog<String>(
  ///   title: 'Select Items',
  ///   items: ['Item 1', 'Item 2', 'Item 3'],
  ///   itemBuilder: (context, value) => Text(value),
  ///   // ... other parameters ...
  /// );
  /// ```
  MultiSelectableDialog({
    required this.title,
    this.titleWidget,
    this.titleStyle,
    this.titleBackgroundColor,
    required this.items,
    required this.itemBuilder,
    this.selectedItemBuilder,
    this.initialSelectedItems,
    this.dialogButton,
    this.initiallyMultiSelectAllItems = false,
    this.selectionType = SelectionType.checkboxTap,
    this.elevation = 10.0,
    this.dialogWidth,
    this.dialogHeight,
    this.titleHeight = 60.0,
    this.dialogBorderRadius = 4.0,
    this.showSelectedTextWidget = true,
    this.selectedTextStyle,
    this.selectedTextBuilder,
  })  : assert(
          !(initiallyMultiSelectAllItems && initialSelectedItems != null),
          "Either 'initiallyMultiSelectAllItems' or 'initialSelectedItems' should be provided.",
        ),
        assert(
          (selectionType != SelectionType.itemTap || selectedItemBuilder != null),
          "If selectionType is '[SelectionType.itemTap]',"
          " 'selectedItemBuilder' should be implemented to differentiate the selected and un-selected items",
        ),
        assert(
          ((initialSelectedItems?.length ?? 0) <= items.length),
          "[initialSelectedItems] should be a sublist of [items]."
          " No strange values should be provided inside initialSelectedItems",
        );

  /// Displays the multi-selectable dialog and returns a [Future] that resolves when the dialog is dismissed.
  ///
  /// This method shows the multi-selectable dialog on the screen and returns a [Future]
  /// that resolves to the list of selected items when the dialog is dismissed.
  ///
  /// Example:
  /// ```dart
  /// var selectedItems = await multiSelectableDialog.show(context);
  /// print('Selected items: $selectedItems');
  /// ```
  Future<List<T>?> show(BuildContext context) async {
    initialSelectedItems?.removeWhere((element) => !items.contains(element));
    Size screenSize = MediaQuery.of(context).size;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    List<T> selectedItems = initialSelectedItems != null ? List.from(initialSelectedItems!) : [];
    ValueNotifier<int> selectedItemsCount = ValueNotifier(selectedItems.length);
    if (initiallyMultiSelectAllItems) {
      selectedItems = List.from(items);
    }

    return await showDialog<List<T>>(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            elevation: elevation,
            borderRadius: BorderRadius.circular(4.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: dialogWidth ?? (isPortrait ? screenSize.width : screenSize.height) * 0.85,
                maxWidth: dialogWidth ?? (isPortrait ? screenSize.width : screenSize.height) * 0.85,
                maxHeight: dialogHeight ?? (isPortrait ? screenSize.height : screenSize.width) * 0.85,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // height: titleHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: titleBackgroundColor ?? Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: titleWidget ??
                              Text(
                                title,
                                style: titleStyle ??
                                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: Colors.white,
                                        ),
                              ),
                        ),
                        if (dialogButton == null)
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(selectedItems),
                            icon: const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (showSelectedTextWidget)
                    ValueListenableBuilder(
                      valueListenable: selectedItemsCount,
                      builder: (context, value, child) {
                        return selectedTextBuilder?.call(selectedItems) ??
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              child: Text(
                                "${selectedItems.length} Selected",
                                style: selectedTextStyle,
                              ),
                            );
                      },
                    ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: ListView.builder(
                      itemCount: items.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
                          child: ValueListenableBuilder(
                            valueListenable: selectedItemsCount,
                            builder: (context, value, child) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: selectionType == SelectionType.checkboxTap
                                          ? null
                                          : () {
                                              if (!selectedItems.contains(items[index])) {
                                                selectedItems.add(items[index]);
                                              } else {
                                                selectedItems.remove(items[index]);
                                              }
                                              selectedItemsCount.value += 1;
                                            },
                                      child: selectedItems.contains(items[index]) && selectedItemBuilder != null
                                          ? selectedItemBuilder!.call(context, items[index])
                                          : itemBuilder.call(context, items[index]),
                                    ),
                                  ),
                                  if (selectionType == SelectionType.checkboxTap)
                                    Checkbox(
                                      side: BorderSide(
                                        color: Theme.of(context).colorScheme.outline,
                                        width: 1.5,
                                      ),
                                      value: selectedItems.contains(items[index]),
                                      onChanged: (isChecked) {
                                        if (isChecked ?? false) {
                                          selectedItems.add(items[index]);
                                        } else {
                                          selectedItems.remove(items[index]);
                                        }
                                        selectedItemsCount.value += 1;
                                      },
                                    ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  if (dialogButton?.positiveButton != null || dialogButton?.negativeButton != null)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (dialogButton!.negativeButton != null)
                            InkWell(
                              onTap: dialogButton!.onNegativeButtonPressed ?? () => Navigator.of(context).pop(),
                              child: dialogButton!.negativeButton!,
                            ),
                          const SizedBox(width: 10.0),
                          if (dialogButton!.positiveButton != null)
                            InkWell(
                              onTap: dialogButton!.onPositiveButtonPressed ??
                                  () => Navigator.of(context).pop(selectedItems),
                              child: dialogButton!.positiveButton!,
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
