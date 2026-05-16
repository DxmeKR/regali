String escapeForRegex(String input) {
  return input.replaceAllMapped(RegExp(r'[.*+?^${}()|[\]\\]'), (Match match) {
    return '\\${match[0]}';
  });
}
