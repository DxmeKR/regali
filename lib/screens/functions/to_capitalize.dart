extension StringCasingExtension on String {
  String toCapitalized() {
    if (isEmpty) return '';
    return this[0].toUpperCase() + substring(1);
  }
}
