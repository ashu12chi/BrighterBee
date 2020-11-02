import 'dart:io';

import 'package:brighter_bee/app_screens/photo_viewer.dart';
import 'package:brighter_bee/helpers/path_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefyr/zefyr.dart';

/*
* @author: Ashutosh Chitranshi,Nishchal Siddharth Pandey
* 1 October, 2020
* This file has implementations of ZefyrImageDelegate interface for image handling in ZefyrField and ZefyrView.
*/

class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
  // to be used in ZefyrField
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
    return InkWell(
        child: CachedNetworkImage(
          placeholder: (context, url) => CircularProgressIndicator(),
          imageUrl: key,
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PhotoViewerCached(key)));
        });
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;
}

class CardZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
  // To be used in ZefyrView
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
    return Text('[Image here, open post to view]',
        style: TextStyle(color: Colors.grey));
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;
}
