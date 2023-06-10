import 'package:flutter/foundation.dart';

class ProgressProvider with ChangeNotifier {
  int? _day;

  double? _diet;
  double? _picture;
  double? _reading;
  double? _workout;
  double? _water;

  int? get day => _day;
  double? get diet => _diet;
  double? get picture => _picture;
  double? get reading => _reading;
  double? get workout => _workout;
  double? get water => _water;

  void setDay(int? day) {
    _day = day;
    notifyListeners();
  }

  void setDiet(double? diet) {
    _diet = diet;
    notifyListeners();
  }

  void setReading(double? reading) {
    _reading = reading;
    notifyListeners();
  }

  void setPicture(double? picture) {
    _picture = picture;
    notifyListeners();
  }

  void setWorkout(double? workout) {
    _workout = workout;
    notifyListeners();
  }

  void setWater(double? water) {
    _water = water;
    notifyListeners();
  }

  void setProgress(int? day, double? diet, double? reading, double? picture,
      double? workout, double? water) {
    _day = day;
    _diet = diet;
    _reading = reading;
    _picture = picture;
    _workout = workout;
    _water = water;
    notifyListeners();
  }
}
