import 'package:flutter/material.dart';
import 'package:versatile_dialogs/loading_dialog.dart';
import 'package:versatile_dialogs/multi_value_picker_dialog.dart';

import 'common/multi_dialog_selection_type.dart';
import 'common/dialog_buttons.dart';

/// A dialog that allows users to pick multiple values from a list of items.
class LazyMultiValuePickerDialog<T> {
  /// The (optional) title of the dialog is displayed in a large font at the top of the dialog.
  ///
  /// Typically a String or a widget representing the title.
  final String? title;

  /// Widget representing the title. If provided, [title], [titleBackgroundColor], [showCloseIcon],
  /// and [titleStyle] should not be provided.
  final Widget? titleWidget;

  /// The style to use for the title text.
  ///
  /// If null, [ThemeData.textTheme.headlineMedium] is used.
  final TextStyle? titleStyle;

  /// The background color for the title bar of the dialog.
  final Color? titleBackgroundColor;

  /// A function that asynchronously fetches a list of items to be displayed in the dialog.
  final Future<List<T>?> Function() asyncItems;

  /// A builder function that returns a widget to display each item in the list.
  ///
  /// The builder takes the current [BuildContext] and the item value.
  final Widget Function(BuildContext context, T value, int index) itemBuilder;

  /// A builder function that returns a widget to display the selected item.
  ///
  /// The builder takes the current [BuildContext] and the selected item value.
  final Widget Function(BuildContext context, T value, int index)?
      selectedItemBuilder;

  /// The initial list of items to be selected when the dialog is displayed.
  final List<T>? initialSelectedItems;

  /// Custom buttons to be displayed in the dialog.
  ///
  /// If null, default buttons (if any) will be used.
  final DialogButton? dialogButton;

  /// Whether to initially select all items in the list.
  final bool initiallyMultiSelectAllItems;

  /// The selection type for the dialog.
  ///
  /// Determines whether the user can select items by tapping on the item or by tapping a checkbox.
  final MultiDialogSelectionType selectionType;

  /// The elevation of the dialog.
  final double elevation;

  /// The width of the dialog.
  final double? dialogWidth;

  /// The height of the dialog.
  final double? dialogHeight;

  /// The height of the title bar.
  final double titleHeight;

  /// The border radius of the dialog.
  final double dialogBorderRadius;

  /// Whether to show a widget displaying the count of selected items.
  final bool showSelectedTextWidget;

  /// The style of the widget displaying the count of selected items.
  final TextStyle? selectedTextStyle;

  /// A builder function that returns a widget to display the count of selected items.
  ///
  /// The builder takes a list of selected items and returns a widget.
  final Widget Function(List<T>? value)? selectedTextBuilder;

  /// Message to be displayed during the loading of items.
  ///
  /// If [loadingDialog] is provided, this message is ignored.
  final String? loadingMessage;

  /// Custom loading dialog to be displayed while fetching items.
  ///
  /// If provided, [loadingMessage] is ignored.
  final LoadingDialog? loadingDialog;

  /// Creates a LazyMultiValuePickerDialog.
  ///
  /// If [titleWidget] is provided, [title], [titleBackgroundColor], [showCloseIcon],
  /// and [titleStyle] should not be provided.
  ///
  /// Should not provide both [loadingMessage] and [loadingDialog].
  LazyMultiValuePickerDialog({
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.titleBackgroundColor,
    required this.asyncItems,
    required this.itemBuilder,
    this.selectedItemBuilder,
    this.initialSelectedItems,
    this.dialogButton,
    this.initiallyMultiSelectAllItems = false,
    this.selectionType = MultiDialogSelectionType.checkboxTap,
    this.elevation = 10.0,
    this.dialogWidth,
    this.dialogHeight,
    this.titleHeight = 60.0,
    this.dialogBorderRadius = 4.0,
    this.showSelectedTextWidget = true,
    this.selectedTextStyle,
    this.selectedTextBuilder,
    this.loadingMessage,
    this.loadingDialog,
  })  : assert(
          !(initiallyMultiSelectAllItems && initialSelectedItems != null),
          "Either 'initiallyMultiSelectAllItems' or 'initialSelectedItems' should be provided.",
        ),
        assert(
          (selectionType != MultiDialogSelectionType.itemTap ||
              selectedItemBuilder != null),
          "If selectionType is '[SelectionType.itemTap]',"
          " 'selectedItemBuilder' should be implemented to differentiate the selected and un-selected items",
        );

  /// Displays the dialog and returns the selected items.
  ///
  /// If [loadingDialog] is provided, it will be displayed while fetching items.
  /// Returns null if no item is selected or fetching items fails.
  Future<List<T>?> show(BuildContext context) async {
    LoadingDialog loadingDialog = this.loadingDialog ??
        LoadingDialog(message: loadingMessage ?? 'Fetching Data');
    loadingDialog.show(context);

    List<T>? items = await asyncItems.call();

    if (context.mounted) loadingDialog.dismiss(context);

    if (context.mounted && items != null) {
      MultiValuePickerDialog<T> dialog = MultiValuePickerDialog(
        title: title,
        titleWidget: titleWidget,
        titleStyle: titleStyle,
        titleBackgroundColor: titleBackgroundColor,
        items: items,
        itemBuilder: itemBuilder,
        selectedItemBuilder: selectedItemBuilder,
        initialSelectedItems: initialSelectedItems,
        dialogButton: dialogButton,
        initiallyMultiSelectAllItems: initiallyMultiSelectAllItems,
        selectionType: selectionType,
        elevation: elevation,
        dialogWidth: dialogWidth,
        titleHeight: titleHeight,
        dialogBorderRadius: dialogBorderRadius,
        dialogHeight: dialogHeight,
        showSelectedTextWidget: showSelectedTextWidget,
        selectedTextBuilder: selectedTextBuilder,
        selectedTextStyle: selectedTextStyle,
      );

      return await dialog.show(context);
    }

    return null;
  }
}
