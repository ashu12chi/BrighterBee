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
  ChewieController _chewieController;
  _ChewieDemoState(this.videoUrl);
  VideoPlayerController _controller;
  Future<void> _future;

  String videoUrl;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videoUrl);
    _future = initVideoPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initVideoPlayer() async {
    await _controller.initialize();
    setState(() {
      _chewieController = ChewieController(
          videoPlayerController: _controller,
          aspectRatio: _controller.value.aspectRatio,
          autoPlay: true,
          looping: false,
          placeholder: buildPlaceholderImage());
    });
  }

  buildPlaceholderImage() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return buildPlaceholderImage();

        return Center(
          child: Chewie(
            controller: _chewieController,
          ),
        );
      },
    );
  }
}
