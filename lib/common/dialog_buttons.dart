import 'package:flutter/material.dart';

/// A utility class representing positive and negative buttons for a dialog.
class DialogButton {
  /// The build context for which the buttons are created.
  ///
  /// This is required to access the current theme and context-specific
  /// resources for button styling.
  final BuildContext context;

  /// The (optional) name or label for the positive button.
  ///
  /// This parameter allows you to specify the text to be displayed on the
  /// positive button. If provided, it will create a default-styled button.
  final String? positiveButtonName;

  /// The background color for the positive button.
  ///
  /// If not provided, it defaults to the primary color of the current theme.
  final Color? positiveButtonBackgroundColor;

  /// The style for the positive button text.
  ///
  /// If not provided, it defaults to the medium-sized title text style from
  /// the current theme.
  final TextStyle? positiveButtonStyle;

  /// The (optional) custom widget for the positive button.
  ///
  /// If provided, it will be used as the positive button instead of the default
  /// button created from [positiveButtonName].
  final Widget? positiveButtonWidget;

  /// The (optional) name or label for the negative button.
  ///
  /// This parameter allows you to specify the text to be displayed on the
  /// negative button. If provided, it will create a default-styled button.
  final String? negativeButtonName;

  /// The background color for the negative button.
  ///
  /// If not provided, it defaults to the background color of the current theme.
  final Color? negativeButtonBackgroundColor;

  /// The style for the negative button text.
  ///
  /// If not provided, it defaults to the medium-sized title text style from
  /// the current theme with the primary color.
  final TextStyle? negativeButtonStyle;

  /// The (optional) custom widget for the negative button.
  ///
  /// If provided, it will be used as the negative button instead of the default
  /// button created from [negativeButtonName].
  final Widget? negativeButtonWidget;

  /// A callback function to be executed when the positive button is pressed.
  Function()? onPositiveButtonPressed;

  /// A callback function to be executed when the negative button is pressed.
  Function()? onNegativeButtonPressed;

  /// Creates a [DialogButton] instance with the specified parameters.
  ///
  /// This constructor allows you to create a new [DialogButton] instance with
  /// the required and optional parameters. Either [positiveButtonName] or
  /// [positiveButtonWidget] can be provided, but not both. Similarly,
  /// either [negativeButtonName] or [negativeButtonWidget] can be provided,
  /// but not both.
  ///
  /// Example:
  /// ```dart
  /// var dialogButton = DialogButton(
  ///   context: context,
  ///   positiveButtonName: 'OK',
  ///   // ... other parameters ...
  /// );
  /// ```
  DialogButton({
    required this.context,
    this.positiveButtonName,
    this.positiveButtonBackgroundColor,
    this.positiveButtonStyle,
    this.positiveButtonWidget,
    this.negativeButtonName,
    this.negativeButtonBackgroundColor,
    this.negativeButtonStyle,
    this.negativeButtonWidget,
    this.onPositiveButtonPressed,
    this.onNegativeButtonPressed,
  })  : assert(
          (positiveButtonName == null || positiveButtonWidget == null),
          "Cannot provide both positiveButtonName and positiveButtonWidget",
        ),
        assert(
          (negativeButtonName == null || negativeButtonWidget == null),
          "Cannot provide both negativeButtonName and negativeButtonWidget",
        );

  /// The (optional) widget for the positive button.
  ///
  /// This getter returns a styled widget for the positive button based on the
  /// provided parameters. If [positiveButtonName] is provided, it creates a
  /// default-styled button; otherwise, it uses [positiveButtonWidget].
  Widget? get positiveButton => positiveButtonName != null
      ? Container(
          decoration: BoxDecoration(
            color: positiveButtonBackgroundColor ?? Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: positiveButtonBackgroundColor ?? Theme.of(context).colorScheme.primary,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 20.0,
          ),
          child: Text(
            positiveButtonName!,
            overflow: TextOverflow.ellipsis,
            style: positiveButtonStyle ??
                Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
          ),
        )
      : positiveButtonWidget;

  /// The (optional) widget for the negative button.
  ///
  /// This getter returns a styled widget for the negative button based on the
  /// provided parameters. If [negativeButtonName] is provided, it creates a
  /// default-styled button; otherwise, it uses [negativeButtonWidget].
  Widget? get negativeButton => negativeButtonName != null
      ? Container(
          decoration: BoxDecoration(
            color: negativeButtonBackgroundColor ?? Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: positiveButtonBackgroundColor ?? Theme.of(context).colorScheme.primary,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 20.0,
          ),
          child: Text(
            negativeButtonName!,
            overflow: TextOverflow.ellipsis,
            style: negativeButtonStyle ??
                Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
          ),
        )
      : negativeButtonWidget;
}
