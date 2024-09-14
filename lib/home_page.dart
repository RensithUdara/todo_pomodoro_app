import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Keep AppBar transparent to overlay on the light gradient background
      appBar: AppBar(
        title: const Text(
          'To-Do Pomodoro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black87, // Dark text for contrast
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black87), // Dark icons
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Light gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.lightBlueAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: kToolbarHeight + 20),
              _buildTaskList(context),
              _buildPomodoroTimer(context),
            ],
          ),
        ],
      ),
      // Floating action button with "+" icon
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskModal(context),
        backgroundColor: Colors.orangeAccent, // Highlighted color
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = taskProvider.tasks[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: Icon(
                task.priority == 1
                    ? Icons.flag
                    : task.priority == 2
                        ? Icons.outlined_flag
                        : Icons.assistant_photo,
                color: task.priority == 1
                    ? Colors.green
                    : task.priority == 2
                        ? Colors.orange
                        : Colors.red,
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      taskProvider.toggleTaskCompletion(index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      taskProvider.removeTask(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPomodoroTimer(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final minutes =
        (taskProvider.remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds =
        (taskProvider.remainingTime % 60).toString().padLeft(2, '0');
    final progress = 1 - (taskProvider.remainingTime / 1500);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                ),
              ),
              Text(
                '$minutes:$seconds',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Dark text for contrast
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Control Buttons with Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Start Button with Icon
              IconButton(
                iconSize: 40,
                icon: Icon(
                  Icons.play_arrow,
                  color:
                      taskProvider.isRunning ? Colors.grey : Colors.greenAccent,
                ),
                onPressed: taskProvider.isRunning
                    ? null
                    : () => taskProvider.startPomodoro(),
              ),
              const SizedBox(width: 20),
              // Stop Button with Icon
              IconButton(
                iconSize: 40,
                icon: Icon(
                  Icons.stop,
                  color:
                      taskProvider.isRunning ? Colors.redAccent : Colors.grey,
                ),
                onPressed: taskProvider.isRunning
                    ? () => taskProvider.stopPomodoro()
                    : null,
              ),
              const SizedBox(width: 20),
              // Reset Button with Icon
              IconButton(
                iconSize: 40,
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.blueAccent,
                ),
                onPressed: () => taskProvider.resetPomodoro(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final TextEditingController taskController = TextEditingController();
    int priority = 1; // Default priority

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      isScrollControlled: true, // To make modal full height
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 50,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const Text(
                'Add New Task',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                  hintText: 'Task Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text(
                    'Priority:',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(width: 20),
                  DropdownButton<int>(
                    value: priority,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Low')),
                      DropdownMenuItem(value: 2, child: Text('Medium')),
                      DropdownMenuItem(value: 3, child: Text('High')),
                    ],
                    onChanged: (value) {
                      priority = value!;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 0),
                ),
                onPressed: () {
                  if (taskController.text.trim().isNotEmpty) {
                    taskProvider.addTask(
                      taskController.text.trim(),
                      priority: priority,
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Add Task',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
