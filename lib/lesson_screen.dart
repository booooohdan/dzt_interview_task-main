// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:dzt_interview_task/providers/lesson_provider.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

import 'package:dzt_interview_task/audio_player_widget.dart';
import 'package:dzt_interview_task/lesson.dart';
import 'package:dzt_interview_task/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

// TODO: Implement new feature per design
// Design url: https://www.figma.com/file/JyLQZote5XKx3GrzM75Igg/Test?type=design&node-id=0-1&mode=design&t=s7dQwNTEK6yFmyTI-0

class LessonScreen extends StatefulWidget {
  const LessonScreen({
    super.key,
    required this.courseId,
    required this.lesson,
  });

  final String courseId;
  final Lesson lesson;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _animations;
  final random = Random();

  String htmlData = '';
  List<HtmlExtension> htmlExtensions = [];
  Offset position = const Offset(0, 0);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animations = List.generate(
      5,
      (index) => Tween<Offset>(
        begin: const Offset(-50, -50),
        end: const Offset(-50, -50),
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeIn,
        ),
      ),
    );

    htmlData = textWithSpecialCharacter(
      text: widget.lesson.text,
      character: 'ґ',
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
                title: Text(
              widget.lesson.title,
              style: const TextStyle(color: secondaryColor),
            )),
            body: Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16.0, left: 16.0, right: 16.0),
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
                            child: Html(
                              data: htmlData,
                              extensions: htmlExtensions,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
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
              ],
            ),
          ),
          for (int i = 0; i < _animations.length; i++)
            AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: _animations[i].value,
                  child: Image.asset('assets/bonus_energy.png'),
                );
              },
            ),
        ],
      ),
    );
  }

  String textWithSpecialCharacter({
    required String text,
    required String character,
  }) {
    dom.Document document = parse(text);
    List<dom.Element> elements = document.body!
        .querySelectorAll('span')
        .where((element) => element.innerHtml.contains('ґ'))
        .toList();

    List<String> classes =
        elements.map((element) => element.attributes['class'] ?? '').toList();

    String result = text;
    int index = 0;

    for (int i = 0; i < text.length; i++) {
      if (text[i] == character) {
        htmlExtensions.add(
          TagExtension(
            tagsToExtend: {"flutter-$index"},
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) async {
                position = details.globalPosition;
                final lessonProvider = context.read<LessonProvider>();

                if (lessonProvider.isSpecialCharacterFound &&
                    lessonProvider.tapCounts[index] == 0) {
                  launchAnimation();
                  lessonProvider.tapCounts[index] =
                      lessonProvider.tapCounts[index] + 1;
                }

                if (!lessonProvider.isSpecialCharacterFound) {
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Center(
                          child: Text('Вітаємо!',
                              style: TextStyle(
                                fontSize: 26,
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                              ))),
                      content: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/confetti.png',
                            ), // replace with your image path
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ви знайшли точку Ґ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor),
                            ),
                            SizedBox(height: 16),
                            Text(
                                'Уважно читайте тексти уроків і ви знайдете ще не одну точку ґ.\n За кожну таку знахідку ви отримаєте +5 енергії.',
                                style: TextStyle(
                                    fontSize: 16, color: secondaryColor),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      actions: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              launchAnimation();
                              lessonProvider.isSpecialCharacterFound = true;
                            },
                            child: const Text(
                              'Клас',
                              style: TextStyle(fontSize: 16, color: beigeColor),
                            ),
                          ),
                        ),
                      ],
                      actionsAlignment: MainAxisAlignment.center,
                      actionsPadding: const EdgeInsets.only(bottom: 36),
                    ),
                  );
                }
              },
              child: ElTooltip(
                timeout: const Duration(seconds: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                showModal: false,
                color: context.read<LessonProvider>().tapCounts[index] == 1
                    ? Colors.yellow[100]!
                    : Colors.black38,
                content: context.read<LessonProvider>().tapCounts[index] == 1
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('+5', style: TextStyle(fontSize: 16)),
                          Image.asset('assets/bonus_energy.png'),
                        ],
                      )
                    : const Text(
                        'Цю точку ґ ви вже знайшли',
                        style: TextStyle(color: Colors.white),
                      ),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color:
                            context.read<LessonProvider>().tapCounts[index] == 1
                                ? Colors.yellow[200]!
                                : Colors.transparent,
                        blurRadius: 3,
                        spreadRadius: 3,
                        blurStyle: BlurStyle.solid,
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    character,
                    style: getTextStyle(classes[index]),
                  ),
                ),
              ),
            ),
          ),
        );

        result =
            result.replaceFirst(character, '<flutter-$index></flutter-$index>');
        index++;
      }
    }

    return result;
  }

  void launchAnimation() {
    _animationController.reset();
    _animations = List.generate(
      _animations.length,
      (i) => Tween<Offset>(
        begin: position,
        end: Offset(
          200 + random.nextDouble() * 200,
          -50 - random.nextDouble() * 50,
        ),
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.ease,
        ),
      ),
    );

    _animationController.forward();
  }

  TextStyle getTextStyle(String cssClass) {
    if (cssClass.contains('c3')) {
      return const TextStyle(
        fontSize: 20.0,
        height: 20 / 16,
        fontFamily: 'Arial',
        fontStyle: FontStyle.italic,
        color: Color(0xFF48575C),
        fontWeight: FontWeight.w400,
      );
    } else if (cssClass.contains('c0')) {
      return const TextStyle(
        fontSize: 20.0,
        height: 20 / 16,
        fontFamily: 'Arial',
        color: Color(0xFF48575C),
        fontWeight: FontWeight.w400,
      );
    }

    return const TextStyle();
  }
}
