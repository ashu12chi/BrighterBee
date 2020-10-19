import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieDemo extends StatefulWidget {
  String _videoUrl;

  ChewieDemo(this._videoUrl);

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState(_videoUrl);
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  String videoUrl;

  _ChewieDemoState(this.videoUrl);

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: false,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Chewie(
        controller: _chewieController,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
