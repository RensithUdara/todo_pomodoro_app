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
  // List to hold tasks
  List<Task> _tasks = [];

  // Pomodoro timer variables
  bool _isRunning = false;
  int _remainingTime = 1500; // 25 minutes in seconds
  Timer? _timer;

  // Getters for tasks and timer status
  List<Task> get tasks => _tasks;
  bool get isRunning => _isRunning;
  int get remainingTime => _remainingTime;

  /// Adds a new task to the list
  void addTask(String title, {int priority = 1}) {
    _tasks.add(Task(title: title, priority: priority));
    notifyListeners();
  }

  /// Removes a task from the list by index
  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  /// Toggles the completion status of a task
  void toggleTaskCompletion(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    notifyListeners();
  }

  /// Starts the Pomodoro timer
  void startPomodoro() {
    if (_isRunning) return; // Prevent multiple timers
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        _stopTimer();
        // Optionally, you can add code here to notify the user that the timer has finished
      }
    });
    notifyListeners();
  }

  /// Stops the Pomodoro timer
  void stopPomodoro() {
    _stopTimer();
    notifyListeners();
  }

  /// Resets the Pomodoro timer to the initial state
  void resetPomodoro() {
    _stopTimer();
    _remainingTime = 1500; // Reset to 25 minutes
    notifyListeners();
  }

  /// Private method to stop the timer
  void _stopTimer() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
  }
}
