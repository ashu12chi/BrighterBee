import 'dart:io';

import 'package:brighter_bee/helpers/path_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefyr/zefyr.dart';

class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
  @override
  Future<String> pickImage(ImageSource source) async {
    final PickedFile file = await ImagePicker().getImage(source: source);
    if (file == null) return null;
    File media = File(file.path);

    StorageUploadTask uploadTask;
    String fileName = getFileName(media);
    uploadTask = FirebaseStorage.instance
        .ref()
        .child('posts/IMG_$fileName')
        .putFile(media);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String url = await storageSnap.ref.getDownloadURL();

    return url;
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    return Image.network(key);
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;
}

class CardZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
  @override
  Future<String> pickImage(ImageSource source) async {
    final PickedFile file = await ImagePicker().getImage(source: source);
    if (file == null) return null;
    File media = File(file.path);

    StorageUploadTask uploadTask;
    String fileName = getFileName(media);
    uploadTask = FirebaseStorage.instance
        .ref()
        .child('posts/IMG_$fileName')
        .putFile(media);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String url = await storageSnap.ref.getDownloadURL();

    return url;
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    return null;
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;
}
