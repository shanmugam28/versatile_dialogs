import 'package:flutter/material.dart';
import 'package:versatile_dialogs/loading_dialog.dart';

import 'dialog_buttons.dart';

/// A dialog that allows users to pick a single value from a future list of items.
class LazySingleValuePickerDialog<T> {
  /// The (optional) title of the dialog is displayed in a large font at the top of the dialog.
  ///
  /// Typically a String or a widget representing the title.
  final String? title;

  /// Widget representing the title. If provided, [title], [titleBackgroundColor],
  /// [showCloseIcon], and [titleStyle] should not be provided.
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
  final Widget Function(BuildContext context, T value) itemBuilder;

  /// Custom buttons to be displayed in the dialog.
  ///
  /// If null, default buttons (if any) will be used.
  final DialogButton? dialogButton;

  /// Whether the dialog can be dismissed by tapping outside the dialog.
  final bool barrierDismissible;

  /// Whether to show a close icon in the title bar.
  final bool showCloseIcon;

  /// The height of the title bar.
  final double titleHeight;

  /// The elevation of the dialog.
  final double elevation;

  /// The width of the dialog.
  final double? dialogWidth;

  /// The height of the dialog.
  final double? dialogHeight;

  /// The border radius of the dialog.
  final double dialogBorderRadius;

  /// Message to be displayed during the loading of items.
  ///
  /// If [loadingDialog] is provided, this message is ignored.
  final String? loadingMessage;

  /// Custom loading dialog to be displayed while fetching items.
  ///
  /// If provided, [loadingMessage] is ignored.
  final LoadingDialog? loadingDialog;

  /// Creates a LazySingleValuePickerDialog.
  ///
  /// If [titleWidget] is provided, [title], [titleBackgroundColor], [showCloseIcon],
  /// and [titleStyle] should not be provided.
  ///
  /// Should not provide both [loadingMessage] and [loadingDialog].
  LazySingleValuePickerDialog({
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.titleBackgroundColor,
    required this.asyncItems,
    required this.itemBuilder,
    this.dialogButton,
    this.barrierDismissible = true,
    this.showCloseIcon = false,
    this.elevation = 10.0,
    this.dialogWidth,
    this.dialogHeight,
    this.titleHeight = 60.0,
    this.dialogBorderRadius = 4.0,
    this.loadingMessage,
    this.loadingDialog,
  })  : assert(
          (titleWidget == null ||
              (title == null && titleBackgroundColor == null && !showCloseIcon && titleStyle == null)),
          "if titleWidget is provided, then title, titleBackgroundColor, showCloseIcon, titleStyle should not be provided",
        ),
        assert(
          (loadingMessage == null || loadingDialog == null),
          "Should not provide both loadingMessage and loadingDialog",
        );

  /// Displays the dialog and returns the selected item.
  ///
  /// If [loadingDialog] is provided, it will be displayed while fetching items.
  /// Returns null if no item is selected or fetching items fails.
  Future<T?> show(BuildContext context) async {
    LoadingDialog loadingDialog = this.loadingDialog ?? LoadingDialog(message: loadingMessage ?? 'Fetching Data');

    loadingDialog.show(context);

    List<T>? items = await asyncItems.call();
    if (context.mounted) loadingDialog.dismiss(context);

    if (context.mounted && items != null) {
      Size screenSize = MediaQuery.of(context).size;
      bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      return await showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return Center(
            child: Material(
              elevation: elevation,
              borderRadius: BorderRadius.circular(dialogBorderRadius),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: dialogWidth ?? (isPortrait ? screenSize.width : screenSize.height) * 0.85,
                  minWidth: dialogWidth ?? (isPortrait ? screenSize.width : screenSize.height) * 0.85,
                  maxHeight: dialogHeight ?? (isPortrait ? screenSize.height : screenSize.width) * 0.85,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null || titleWidget != null || showCloseIcon)
                      titleWidget ??
                          Container(
                            height: titleHeight,
                            padding: EdgeInsets.only(
                              left: showCloseIcon ? 2.0 : 20.0,
                              right: 20.0,
                            ),
                            decoration: BoxDecoration(
                              color: titleBackgroundColor ?? Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(dialogBorderRadius),
                                topRight: Radius.circular(dialogBorderRadius),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                if (showCloseIcon)
                                  IconButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (showCloseIcon) const SizedBox(width: 5.0),
                                if (title != null)
                                  Expanded(
                                    child: Text(
                                      title!,
                                      style: titleStyle ??
                                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                color: Colors.white,
                                              ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8.0),
                              onTap: () => Navigator.of(context).pop(items[index]),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: itemBuilder.call(context, items[index]),
                              ),
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
                              Flexible(
                                fit: FlexFit.loose,
                                child: InkWell(
                                  onTap: dialogButton!.onNegativeButtonPressed ?? () => Navigator.of(context).pop(),
                                  child: dialogButton!.negativeButton!,
                                ),
                              ),
                            const SizedBox(width: 10.0),
                            if (dialogButton!.positiveButton != null)
                              Flexible(
                                fit: FlexFit.loose,
                                child: InkWell(
                                  onTap: dialogButton!.onPositiveButtonPressed ?? () => Navigator.of(context).pop(),
                                  child: dialogButton!.positiveButton!,
                                ),
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
    return null;
  }
}
