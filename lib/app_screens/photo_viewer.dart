import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// @author: Nishchal Siddharth Pandey
// Oct 16, 2020
// This will be used for viewing photo in full size

class PhotoViewer extends StatefulWidget {
  final String _url;

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

class PhotoViewerCached extends StatefulWidget {
  final String _url;

  PhotoViewerCached(this._url);

  @override
  _PhotoViewerCachedState createState() => _PhotoViewerCachedState(_url);
}

class _PhotoViewerCachedState extends State<PhotoViewerCached> {
  String _url;

  _PhotoViewerCachedState(this._url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PhotoView(
            imageProvider: CachedNetworkImageProvider(_url),
            enableRotation: true));
  }
}
