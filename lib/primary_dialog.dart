import 'package:flutter/material.dart';

import 'common/dialog_buttons.dart';

/// A customizable dialog that can display a title, description, body, and buttons.
class PrimaryDialog<T> {
  /// The (required) title of the dialog is displayed in a large font at the top
  /// of the dialog.
  ///
  /// This parameter expects a String that represents the main heading or title
  /// for the dialog. It is a required parameter, and the provided title will be
  /// prominently displayed at the top of the dialog box.
  final String title;

  /// the widget for the title
  ///
  /// if provided, then [title], [titleStyle], [titleBackgroundColor] are no use
  final Widget? titleWidget;

  /// The style for the title text.
  ///
  /// If not provided, the default style is used based on the current theme.
  final TextStyle? titleStyle;

  /// The background color for the title area.
  ///
  /// If not provided, the default color is based on the primary color of the
  /// current theme.
  final Color? titleBackgroundColor;

  /// The (optional) description text to be displayed in the dialog.
  ///
  /// This parameter allows you to provide additional information or context
  /// related to the title. Note that either [description] or [body] can be
  /// provided, but not both.
  final String? description;

  /// The style for the description text.
  ///
  /// If not provided, the default style is used based on the current theme.
  final TextStyle? descriptionStyle;

  /// The widget representing the body of the dialog.
  ///
  /// This parameter allows you to include a custom widget as the main content
  /// of the dialog. Note that either [description] or [body] can be provided,
  /// but not both.
  final Widget? body;

  /// The scroll physics for the body content.
  ///
  /// This parameter allows you to customize the scroll physics for the body
  /// content, enabling or disabling scrolling as needed.
  final ScrollPhysics bodyScrollPhysics;

  /// An instance of [DialogButton] representing positive and negative buttons.
  ///
  /// This parameter allows you to define custom buttons for user interaction.
  final DialogButton? dialogButton;

  /// Whether the dialog can be dismissed by tapping outside.
  ///
  /// If set to true (default), tapping outside the dialog will dismiss it.
  final bool barrierDismissible;

  /// The elevation of the dialog.
  ///
  /// This parameter determines the shadow depth of the dialog.
  final double elevation;

  /// The width of the dialog.
  ///
  /// If not provided, it defaults to 85% of the screen width.
  final double? dialogWidth;

  /// The height of the dialog.
  final double? dialogHeight;

  /// The height of the title area.
  ///
  /// This parameter allows you to customize the height of the title area.
  final double? titleHeight;

  /// The border radius of the dialog.
  ///
  /// This parameter allows you to specify the corner radius of the dialog box.
  final double dialogBorderRadius;

  /// Creates a [PrimaryDialog] instance with the specified parameters.
  ///
  /// This constructor allows you to create a new [PrimaryDialog] instance with
  /// the required and optional parameters. The [title] parameter is required,
  /// and either [description] or [body] can be provided, but not both.
  ///
  /// Example:
  /// ```dart
  /// var dialog = PrimaryDialog<bool>(
  ///   title: 'Confirmation',
  ///   // ... other parameters ...
  /// );
  /// ```
  PrimaryDialog({
    required this.title,
    this.titleStyle,
    this.titleBackgroundColor,
    this.titleWidget,
    this.description,
    this.descriptionStyle,
    this.body,
    this.bodyScrollPhysics = const AlwaysScrollableScrollPhysics(),
    this.dialogButton,
    this.barrierDismissible = true,
    this.elevation = 10.0,
    this.dialogWidth,
    this.dialogHeight,
    this.titleHeight = 60.0,
    this.dialogBorderRadius = 4.0,
  })  : assert(
          (description == null || body == null),
          'Cannot add both description and body',
        ),
        assert(
          (description != null || body != null),
          "Either description or body should be provided",
        );

  /// Displays the dialog and returns a [Future] that resolves when the dialog is dismissed.
  ///
  /// This method shows the dialog on the screen and returns a [Future] that
  /// resolves to the value returned by the dialog (of type [T]).
  ///
  /// Example:
  /// ```dart
  /// var dialog = PrimaryDialog<bool>(
  ///   title: 'Confirmation',
  ///   // ... other parameters ...
  /// );
  ///
  /// bool result = await dialog.show(context);
  /// print(result); // true if positive button is pressed, false if negative or dialog is dismissed
  /// ```
  Future<T?> show(BuildContext context) async {
    Size screenSize = MediaQuery.of(context).size;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return await showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Center(
            child: Material(
              elevation: elevation,
              borderRadius: BorderRadius.circular(dialogBorderRadius),
              child: SizedBox(
                width: dialogWidth ?? (isPortrait ? screenSize.width : screenSize.height) * 0.85,
                height: dialogHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: titleHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: titleBackgroundColor ?? Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(dialogBorderRadius),
                          topRight: Radius.circular(dialogBorderRadius),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: titleWidget ??
                          Text(
                            title,
                            style: titleStyle ??
                                Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                    ),
                    if (description != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        child: Text(
                          description!,
                          style: descriptionStyle ?? Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    if (body != null)
                      Flexible(
                        fit: FlexFit.loose,
                        child: SingleChildScrollView(
                          physics: bodyScrollPhysics,
                          child: body!,
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
                                  onTap:
                                      dialogButton!.onNegativeButtonPressed ?? () => Navigator.of(context).pop(false),
                                  child: dialogButton!.negativeButton!,
                                ),
                              ),
                            const SizedBox(width: 10.0),
                            if (dialogButton!.positiveButton != null)
                              Flexible(
                                fit: FlexFit.loose,
                                child: InkWell(
                                  onTap: dialogButton!.onPositiveButtonPressed ?? () => Navigator.of(context).pop(true),
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
          ),
        );
      },
    );
  }
}
