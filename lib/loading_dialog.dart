import 'package:flutter/material.dart';

/// A simple loading dialog that can display a loading indicator and an optional message.
class LoadingDialog {
  /// The (optional) message to be displayed below the loading indicator.
  ///
  /// This parameter allows you to provide additional information or context
  /// while the loading indicator is being displayed.
  final String? message;

  /// The style for the message text.
  ///
  /// If not provided, the default style is used based on the current theme.
  final TextStyle? messageStyle;

  /// The (optional) custom widget for the message.
  ///
  /// If provided, it will be used as the message instead of the default text
  /// created from [message].
  final Widget? messageWidget;

  /// The color for the loading indicator.
  ///
  /// If not provided, it defaults to the primary color of the current theme.
  final Color? progressbarColor;

  /// The (optional) custom widget for the loading indicator.
  ///
  /// If provided, it will be used as the loading indicator instead of the
  /// default CircularProgressIndicator.
  final Widget? progressbarWidget;

  /// Whether the dialog can be dismissed by tapping outside.
  ///
  /// If set to true, tapping outside the dialog will dismiss it. Defaults to false.
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

  /// The border radius of the dialog.
  ///
  /// This parameter allows you to specify the corner radius of the dialog box.
  final double dialogBorderRadius;

  /// Creates a [LoadingDialog] instance with the specified parameters.
  ///
  /// This constructor allows you to create a new [LoadingDialog] instance with
  /// the optional parameters. You can customize the appearance of the loading
  /// dialog by providing values for [message], [messageStyle], [messageWidget],
  /// [progressbarColor], [progressbarWidget], [barrierDismissible],
  /// [elevation], [dialogWidth], [dialogHeight], and [dialogBorderRadius].
  ///
  /// Example:
  /// ```dart
  /// var loadingDialog = LoadingDialog(
  ///   message: 'Loading...',
  ///   // ... other parameters ...
  /// );
  /// ```
  LoadingDialog({
    this.message,
    this.messageStyle,
    this.messageWidget,
    this.progressbarColor,
    this.progressbarWidget,
    this.barrierDismissible = false,
    this.elevation = 10.0,
    this.dialogHeight,
    this.dialogWidth,
    this.dialogBorderRadius = 4.0,
  });

  /// Displays the loading dialog and returns a [Future] that resolves when the dialog is dismissed.
  ///
  /// This method shows the loading dialog on the screen and returns a [Future]
  /// that resolves when the dialog is dismissed.
  ///
  /// Example:
  /// ```dart
  /// var loadingDialog = LoadingDialog(
  ///   message: 'Loading...',
  ///   // ... other parameters ...
  /// );
  ///
  /// await loadingDialog.show(context);
  /// ```
  show(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        Size screenSize = MediaQuery.of(context).size;
        bool isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;

        return Center(
          child: Material(
            elevation: elevation,
            borderRadius: BorderRadius.circular(dialogBorderRadius),
            child: Container(
              width: dialogWidth ??
                  (isPortrait ? screenSize.width : screenSize.height) * 0.85,
              height: dialogHeight,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: progressbarWidget ??
                        CircularProgressIndicator(
                          color: progressbarColor ??
                              Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  if (message != null)
                    Text(
                      message!,
                      style: messageStyle,
                    )
                  else if (messageWidget != null)
                    messageWidget!,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Dismisses the loading dialog.
  ///
  /// This method dismisses the loading dialog that is currently displayed on
  /// the screen.
  ///
  /// Example:
  /// ```dart
  /// var loadingDialog = LoadingDialog(
  ///   message: 'Loading...',
  ///   // ... other parameters ...
  /// );
  ///
  /// await loadingDialog.show(context);
  /// // ... perform some loading task ...
  /// loadingDialog.dismiss(context);
  /// ```
  dismiss(BuildContext context) => Navigator.of(context).pop();
}
