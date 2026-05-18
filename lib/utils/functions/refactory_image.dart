import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;

Future<File> compressAndResizeImage(
  File file, {
  int targetBytes = 900000,
}) async {
  final originalBytes = await file.readAsBytes();
  final originalImage = img.decodeImage(originalBytes);

  if (originalImage == null) return file;

  // Parametri iniziali
  int width = originalImage.width;
  if (width > 2000) width = 2000; // non salire oltre
  int quality = 85;

  File compressedFile = file;
  List<int> encoded = img.encodeJpg(originalImage, quality: quality);
  // se già sotto target, prova a salvare versione jpg ridimensionata con stessa qualità
  if (encoded.length <= targetBytes) {
    final newPath = file.path.replaceFirst(
      RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false),
      '_resized.jpg',
    );
    compressedFile = await File(newPath).writeAsBytes(encoded);
    return compressedFile;
  }

  img.Image current = img.copyResize(originalImage, width: width);

  // ciclo riduzione: prima abbassa quality, poi width se necessario
  while (true) {
    encoded = img.encodeJpg(current, quality: quality);
    if (encoded.length <= targetBytes) {
      final newPath = file.path.replaceFirst(
        RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false),
        '_resized.jpg',
      );
      compressedFile = await File(newPath).writeAsBytes(encoded);
      return compressedFile;
    }

    // riduci qualità finché >=30
    if (quality > 40) {
      quality -= 10;
      continue;
    }

    // se la qualità è bassa, riduci la larghezza (min 400px)
    if (width > 400) {
      width = (width * 0.8).toInt();
      current = img.copyResize(originalImage, width: width);
      quality = 40; // riporta quality a un valore ragionevole dopo resize
      continue;
    }

    // non siamo riusciti a rientrare: salva comunque la versione più compressa possibile
    final newPath = file.path.replaceFirst(
      RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false),
      '_resized.jpg',
    );
    compressedFile = await File(newPath).writeAsBytes(encoded);
    return compressedFile;
  }
}

Future<String> encodeImageToBase64(File file) async {
  final bytes = await file.readAsBytes();
  final base64Str = base64Encode(bytes);
  // manteniamo il prefix data-uri per poter distinguere facilmente
  return 'data:image/jpeg;base64,$base64Str';
}
