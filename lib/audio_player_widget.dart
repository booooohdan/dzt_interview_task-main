import 'package:community_material_icon/community_material_icon.dart';
import 'package:dzt_interview_task/main.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Formats time as: hh:mm:ss or mm:ss if minutes available
String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(':');
}

class AudioPlayerWidget extends StatefulWidget {
  /// Path to the audio in Firebase Storage
  final String? audio;
  final VoidCallback? onCompleted;
  const AudioPlayerWidget({super.key, required this.audio, this.onCompleted});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late String _source;

  final _audioPlayer = AudioPlayer()..setVolume(1.0);
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.audio != null) {
        await _setupAudio();
      }
    });
  }

  @override
  void didUpdateWidget(covariant AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.audio != null) {
        await _setupAudio();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.audio == null) {
      return Container();
    }

    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                _isPlaying
                    ? CommunityMaterialIcons.pause_circle
                    : CommunityMaterialIcons.play_circle,
              ),
              iconSize: 32,
              color: primaryColor,
              onPressed: () async {
                if (_isPlaying) {
                  _audioPlayer.pause();
                } else {
                  _audioPlayer.play();
                }
              },
            ),
            Expanded(
              child: Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await _audioPlayer.seek(position);

                    // try to resume player (e.g. when it finished)
                    await _audioPlayer.play();
                  }),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 64.0, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatTime(_position)),
              Text(formatTime(_duration - _position))
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _setupAudio() async {
    _source = widget.audio!;
    await _audioPlayer.setUrl(_source);
    await _audioPlayer.stop();

    /// Listen to audio position
    _audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() => _position = position);
      }
    });

    /// Listen to audio playing state
    _audioPlayer.playingStream.listen((playing) {
      if (mounted) {
        setState(() => _isPlaying = playing);
      }
    });

    _audioPlayer.playerStateStream.listen((event) async {
      /// Listen to audio complete
      if (event.processingState == ProcessingState.completed) {
        await _audioPlayer.stop();

        if (mounted) {
          setState(() {
            _position = Duration.zero;
            _audioPlayer.seek(_position);
            _isPlaying = false;
            widget.onCompleted?.call();
          });
        }
      }
    });

    /// Listen to audio duration
    _audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration ?? Duration.zero);
      }
    });
  }
}
