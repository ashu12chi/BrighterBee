import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:notustohtml/notustohtml.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:zefyr/zefyr.dart';

/*
* @author: Nishchal Siddharth Pandey
* 19 October, 2020
* This file has code for sharing post in html format to any app like whatsapp / gmail
*/

Future<void> postShareWeb(String community, String postKey, String title,
    int mediaType, String mediaUrl, String content) async {
  NotusDocument document = NotusDocument.fromJson(jsonDecode(content));
  if (mediaType == 1)
    document.format(0, 0, NotusAttribute.embed.image(mediaUrl));
  else if (mediaType == 2) {
    document.insert(0, 'Video link\n');
    document.format(0, 12, NotusAttribute.link.fromString(mediaUrl));
  }
  document.insert(0, '$title\n');
  document.format(0, title.length + 1, NotusAttribute.h1);
  final converter = NotusHtmlCodec();
  String html = '<Title>$title</Title>\n<Body>' +
      converter.encode(document.toDelta()) +
      '\n</Body>';
  File file = await writeHtml(html);
  StorageUploadTask uploadTask;
  String fileName = community + '_' + postKey + '.html';
  uploadTask = FirebaseStorage.instance
      .ref()
      .child('sharedPosts/$fileName')
      .putFile(file);
  StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
  String url = await storageSnap.ref.getDownloadURL();
  await Share.share(
      'Check out this post I found on BrighterBee: $url . BrighterBee is an app to share your ideas among a community of people of your type, download the app here: https://bit.ly/35uR0uy');
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/share.html');
}

Future<File> writeHtml(String html) async {
  final file = await _localFile;

  // Write the file.
  return file.writeAsString(html);
}
