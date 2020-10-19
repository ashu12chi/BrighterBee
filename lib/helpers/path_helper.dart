import 'dart:io';

import 'package:path/path.dart';

String getFileName(File file) {
  return basename(file.path);
}
