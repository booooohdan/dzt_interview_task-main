import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonProvider extends ChangeNotifier {
  bool _isSpecialCharacterFound = false;
  List<int> _tapCounts = [];
  late SharedPreferences sharedPreferences;

  LessonProvider() {
    Future.microtask(() async {
      sharedPreferences = await SharedPreferences.getInstance();

      _isSpecialCharacterFound =
          sharedPreferences.getBool('isSpecialCharacterFound') ?? false;
      _tapCounts = sharedPreferences
              .getStringList('tapCounts')
              ?.map((e) => int.parse(e))
              .toList() ??
          [0, 0, 0, 0, 0];
    });
  }

  List<int> get tapCounts => _tapCounts;
  set tapCounts(List<int> value) {
    sharedPreferences.setStringList(
        'tapCounts', value.map((e) => e.toString()).toList());
    _tapCounts = value;
    notifyListeners();
  }

  bool get isSpecialCharacterFound => _isSpecialCharacterFound;
  set isSpecialCharacterFound(bool value) {
    sharedPreferences.setBool('isSpecialCharacterFound', value);
    _isSpecialCharacterFound = value;
    notifyListeners();
  }
}
