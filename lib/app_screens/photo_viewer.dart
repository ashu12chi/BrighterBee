import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatefulWidget {
  String _url;

  PhotoViewer(this._url);

  @override
  _PhotoViewerState createState() => _PhotoViewerState(_url);
}

class _PhotoViewerState extends State<PhotoViewer> {
  String _url;

  _PhotoViewerState(this._url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            PhotoView(imageProvider: NetworkImage(_url), enableRotation: true));
  }
}
