import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:iptv_app/model/channel.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {
  final Channel channel;
  const PlayerScreen(this.channel, {super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (widget.channel.streamUrl.isEmpty) {
      setState(() => _error = true);
      return;
    }

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.channel.streamUrl),
    );

    try {
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        allowFullScreen: true,
      );
      setState(() {});
    } catch (e) {
      print('Failed to initialize video: $e');
      setState(() => _error = true);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.channel.name)),
        body: const Center(
          child: Text(
            'Cannot play this stream',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.channel.name)),
      body: _chewieController == null
          ? const Center(child: CircularProgressIndicator())
          : Chewie(controller: _chewieController!),
    );
  }
}
