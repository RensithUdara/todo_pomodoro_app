import 'dart:async';
import 'package:flutter/material.dart';

class Task {
  final String title;
  bool isCompleted;
  int priority;

  Task({
    required this.title,
    this.isCompleted = false,
    this.priority = 1,
  });
}

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isRunning = false;
  int _remainingTime = 1500; // Default to 25 minutes
  int _customDuration = 1500; // User-defined duration in seconds
  Timer? _timer;

  List<Task> get tasks => _tasks;
  bool get isRunning => _isRunning;
  int get remainingTime => _remainingTime;
  int get customDuration => _customDuration;

  void addTask(String title, {int priority = 1}) {
    _tasks.add(Task(title: title, priority: priority));
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    notifyListeners();
  }

  /// Sets a new custom duration for the Pomodoro timer
  void setCustomDuration(int seconds) {
    _customDuration = seconds;
    _remainingTime = _customDuration;
    notifyListeners();
  }

  void startPomodoro() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        stopPomodoro();
        // Optional: Add notification or sound alert
      }
    });
    notifyListeners();
  }

  void stopPomodoro() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void resetPomodoro() {
    _isRunning = false;
    _timer?.cancel();
    _remainingTime = _customDuration;
    notifyListeners();
  }
}
