import 'dart:io';

import 'package:path/path.dart';

/*
* @author: Nishchal Siddharth Pandey
* 19 October, 2020
* This file has code for getting file name from full Path.
*/

String getFileName(File file) {
  return basename(file.path);
}
