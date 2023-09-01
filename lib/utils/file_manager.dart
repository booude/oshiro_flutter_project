import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FileManager {
  final book;
  const FileManager({required this.book});

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final id = book.id;
    return File('$path/$id.txt');
  }

  Future<File> writeFile(bool isFavorite) async {
    final file = await _localFile;
    return file.writeAsString('$isFavorite');
  }

  Future<List> readFile() async {
    try {
      final file = await _localFile;
      final fileName = basename(file.path).split('.')[0];
      final contents = await file.readAsString();
      return [fileName, contents];
    } catch (e) {
      return ['', false];
    }
  }
}
