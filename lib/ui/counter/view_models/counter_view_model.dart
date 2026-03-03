import 'package:flutter/material.dart';

class CounterViewModel extends ChangeNotifier {
  int counter;

  CounterViewModel({this.counter = 0});

  void incrementCounter() {
    counter++;
    notifyListeners();
  }

  void decrementCounter() {
    counter--;
    notifyListeners();
  }

  void resetCounter() {
    counter = 0;
    notifyListeners();
  }
}
