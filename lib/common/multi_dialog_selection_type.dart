/// Defines the type of selection behavior in the [MultiValuePickerDialog].
///
/// The [MultiDialogSelectionType] enum is used to specify how items in the [MultiValuePickerDialog]
/// should be selected by users. It has two possible values:
///
/// - [checkboxTap]: Users can select items by tapping on checkboxes.
/// - [itemTap]: Users can select items by tapping directly on the items themselves.
///
/// Example:
/// ```dart
/// SelectionType selectionType = SelectionType.checkboxTap;
/// ```
enum MultiDialogSelectionType {
  /// Users can select items by tapping on checkboxes.
  checkboxTap,

  /// Users can select items by tapping directly on the items themselves.
  itemTap,
}
