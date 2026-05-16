String? obbligatorio(String? value) {
  if (value == null || value.isEmpty) return 'Campo obbligatorio';
  return null;
}
