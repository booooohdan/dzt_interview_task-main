import 'package:dzt_interview_task/audio_player_widget.dart';
import 'package:dzt_interview_task/lesson.dart';
import 'package:dzt_interview_task/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// TODO: Implement new feature per design
// Design url: https://www.figma.com/file/JyLQZote5XKx3GrzM75Igg/Test?type=design&node-id=0-1&mode=design&t=s7dQwNTEK6yFmyTI-0

class LessonScreen extends StatefulWidget {
  final String courseId;
  final Lesson lesson;
  const LessonScreen({super.key, required this.courseId, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.lesson.title,
        style: const TextStyle(color: secondaryColor),
      )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AudioPlayerWidget(
                  audio: widget.lesson.audio,
                  onCompleted: () {
                    // Do nothing
                  }),
              const SizedBox(height: 16),
              Expanded(
                  child: SingleChildScrollView(
                      child: Html(data: widget.lesson.text))),
              const SizedBox(height: 16),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                  onPressed: () {
                    // Do nothing
                  },
                  child: const Text(
                    'Перейти до вправ',
                    style: TextStyle(fontSize: 16, color: beigeColor),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
