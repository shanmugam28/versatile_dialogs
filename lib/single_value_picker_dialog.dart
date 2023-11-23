import 'package:flutter/material.dart';

import 'dialog_buttons.dart';

/// A dialog that allows users to pick a single value from a list of items.
class SingleValuePickerDialog<T> {
  /// The (optional) title of the dialog, displayed at the top.
  final String? title;

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

  /// Configuration for the dialog buttons (positive and negative buttons).
  final DialogButton? dialogButton;

  /// If true, allows dismissing the dialog by tapping outside the content area.
  final bool barrierDismissible;

  /// If true, displays a close icon (clear button) in the title bar.
  final bool showCloseIcon;

  /// (Optional) The height of the title bar.
  final double titleHeight;

  /// The elevation of the dialog.
  final double elevation;

  /// (Optional) The width of the dialog. If not provided, defaults to 85% of the screen width.
  final double? dialogWidth;

  /// (Optional) The height of the dialog. If not provided, defaults to 85% of the screen height.
  final double? dialogHeight;

  /// The border radius of the dialog.
  final double dialogBorderRadius;

  /// Creates a [SingleValuePickerDialog] instance with the specified parameters.
  ///
  /// This constructor allows you to create a new [SingleValuePickerDialog] instance with
  /// the required and optional parameters. You can customize the appearance and behavior
  /// of the dialog by providing values for [title], [titleWidget], [titleStyle],
  /// [titleBackgroundColor], [items], [itemBuilder], [dialogButton], [barrierDismissible],
  /// [showCloseIcon], [elevation], [dialogWidth], [dialogHeight], [titleHeight],
  /// and [dialogBorderRadius].
  ///
  /// Example:
  /// ```dart
  /// var singleValuePickerDialog = SingleValuePickerDialog<String>(
  ///   title: 'Select Item',
  ///   items: ['Item 1', 'Item 2', 'Item 3'],
  ///   itemBuilder: (context, value) => Text(value),
  ///   // ... other parameters ...
  /// );
  /// ```
  SingleValuePickerDialog({
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.titleBackgroundColor,
    required this.items,
    required this.itemBuilder,
    this.dialogButton,
    this.barrierDismissible = true,
    this.showCloseIcon = false,
    this.elevation = 10.0,
    this.dialogWidth,
    this.dialogHeight,
    this.titleHeight = 60.0,
    this.dialogBorderRadius = 4.0,
  }) : assert(
          (titleWidget == null ||
              (title == null && titleBackgroundColor == null && !showCloseIcon && titleStyle == null)),
          "if titleWidget is provided,"
          " then title, titleBackgroundColor, showCloseIcon, titleStyle should not be provided",
        );

  /// Displays the single-value picker dialog and returns a [Future] that resolves when the dialog is dismissed.
  ///
  /// This method shows the single-value picker dialog on the screen and returns a [Future]
  /// that resolves to the selected item when the dialog is dismissed.
  ///
  /// Example:
  /// ```dart
  /// var selectedItem = await singleValuePickerDialog.show(context);
  /// print('Selected item: $selectedItem');
  /// ```
  Future<T?> show(BuildContext context) async {
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
}
