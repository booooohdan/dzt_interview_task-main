import 'package:dzt_interview_task/lesson.dart';
import 'package:dzt_interview_task/lesson_screen.dart';
import 'package:dzt_interview_task/providers/lesson_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const secondaryColor = Color.fromRGBO(72, 87, 92, 1);

const primaryColor = MaterialColor(0xFFFFCC00, {
  50: Color.fromRGBO(255, 204, 0, .1),
  100: Color.fromRGBO(255, 204, 0, .2),
  200: Color.fromRGBO(255, 204, 0, .3),
  300: Color.fromRGBO(255, 204, 0, .4),
  400: Color.fromRGBO(255, 204, 0, .5),
  500: Color.fromRGBO(255, 204, 0, .6),
  600: Color.fromRGBO(255, 204, 0, .7),
  700: Color.fromRGBO(255, 204, 0, .8),
  800: Color.fromRGBO(255, 204, 0, .9),
  900: Color.fromRGBO(255, 204, 0, 1),
});

const beigeColor = MaterialColor(0xFFF8F8F0, {
  50: Color.fromRGBO(248, 248, 240, .1),
  100: Color.fromRGBO(248, 248, 240, .2),
  200: Color.fromRGBO(248, 248, 240, .3),
  300: Color.fromRGBO(248, 248, 240, .4),
  400: Color.fromRGBO(248, 248, 240, .5),
  500: Color.fromRGBO(248, 248, 240, .6),
  600: Color.fromRGBO(248, 248, 240, .7),
  700: Color.fromRGBO(248, 248, 240, .8),
  800: Color.fromRGBO(248, 248, 240, .9),
  900: Color.fromRGBO(248, 248, 240, 1),
});

final lightTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    primaryColor: primaryColor,
    indicatorColor: const Color(0xfff8f7f0),
    shadowColor: const Color(0xffbcc2d0),
    dividerColor: const Color(0xfff2f5fa),
    cardColor: const Color(0xfff8fafc),
    unselectedWidgetColor: Colors.black,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.dark),
      elevation: 2,
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(letterSpacing: 0, color: Color(0xff414654)),
      displayMedium: TextStyle(letterSpacing: 0),
      displaySmall: TextStyle(letterSpacing: 0),
      headlineMedium: TextStyle(
          letterSpacing: 0,
          color: Color(0xff414654),
          fontSize: 18,
          fontWeight: FontWeight.w900),
      headlineSmall:
          TextStyle(letterSpacing: 0, color: secondaryColor, fontSize: 20),
      titleLarge: TextStyle(
          letterSpacing: 0, fontSize: 18, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(letterSpacing: 0, color: Colors.black),
      bodyMedium: TextStyle(letterSpacing: 0, color: secondaryColor),
      titleMedium: TextStyle(letterSpacing: 0, color: Color(0xff414654)),
      titleSmall: TextStyle(letterSpacing: 0, color: secondaryColor),
      bodySmall: TextStyle(
          letterSpacing: 0,
          fontSize: 14,
          color: secondaryColor,
          fontWeight: FontWeight.w400),
      labelSmall: TextStyle(
          letterSpacing: 0,
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w600),
      labelLarge: TextStyle(
          fontSize: 12, color: secondaryColor, fontWeight: FontWeight.w600),
    ),
    colorScheme: const ColorScheme.light(primary: primaryColor)
        .copyWith(primary: primaryColor, background: beigeColor));

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LessonProvider>(
          create: (_) => LessonProvider(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        theme: lightTheme,
        home: FutureBuilder<String>(
          future: rootBundle.loadString('assets/lesson.html'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LessonScreen(
                courseId: 'interview',
                lesson: Lesson(
                  'interview',
                  'Урок 1: звучати',
                  snapshot.data ?? '',
                  'https://firebasestorage.googleapis.com/v0/b/tekstom-0.appspot.com/o/courses%2F45dccaf4-f447-448f-96a5-409945b7410a%2Flessons%2F1%2Faudio.mp3?alt=media&token=0ea5af4b-7831-4163-a633-b449d06ffc6b',
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
