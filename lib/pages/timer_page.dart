import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/timer_mode.dart';

class PomodoroTimerPage extends StatefulWidget {
  final TimerMode selectedMode;

  const PomodoroTimerPage({super.key, required this.selectedMode});

  @override
  State<PomodoroTimerPage> createState() => _PomodoroTimerPageState();
}

class _PomodoroTimerPageState extends State<PomodoroTimerPage> {
  late int remainingSeconds;
  bool isWorkMode = true;
  bool isRunning = false;
  Timer? timer;

  List<Map<String, dynamic>> materiList = []; // dengan centang

  int get workTime {
    switch (widget.selectedMode) {
      case TimerMode.pomodoro:
        return 25 * 60;
      case TimerMode.rule_5217:
        return 52 * 60;
      case TimerMode.ultradian_rhythm:
        return 90 * 60;
    }
  }

  int get breakTime {
    switch (widget.selectedMode) {
      case TimerMode.pomodoro:
        return 5 * 60;
      case TimerMode.rule_5217:
        return 17 * 60;
      case TimerMode.ultradian_rhythm:
        return 20 * 60;
    }
  }

  @override
  void initState() {
    super.initState();
    remainingSeconds = workTime;
  }

  void startTimer() {
    if (isRunning) return;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        pauseTimer();
      }
    });
    setState(() => isRunning = true);
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      remainingSeconds = isWorkMode ? workTime : breakTime;
      isRunning = false;
    });
  }

  void switchMode() {
    timer?.cancel();
    setState(() {
      isWorkMode = !isWorkMode;
      remainingSeconds = isWorkMode ? workTime : breakTime;
      isRunning = false;
    });
  }

  String formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void addMateri(String text) {
    setState(() {
      materiList.add({'text': text, 'done': false});
    });
  }

  void editMateri(int index, String newText) {
    setState(() {
      materiList[index]['text'] = newText;
    });
  }

  void toggleCentang(int index) {
    setState(() {
      materiList[index]['done'] = !materiList[index]['done'];
    });
  }

  void deleteMateri(int index) {
    setState(() {
      materiList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Study Pulse")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Mode: ${isWorkMode ? "Belajar" : "Istirahat"} (${widget.selectedMode.name})',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              formatTime(remainingSeconds),
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(onPressed: startTimer, child: const Text("Start")),
                ElevatedButton(onPressed: pauseTimer, child: const Text("Pause")),
                ElevatedButton(onPressed: resetTimer, child: const Text("Reset")),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: switchMode,
              child: Text("Ganti ke ${isWorkMode ? "Istirahat" : "Belajar"}"),
            ),
            const Divider(height: 40),
            const Text("Daftar Materi", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            ...materiList.asMap().entries.map((entry) {
              int i = entry.key;
              var materi = entry.value;
              return ListTile(
                leading: Checkbox(
                  value: materi['done'],
                  onChanged: (_) => toggleCentang(i),
                ),
                title: Text(
                  materi['text'],
                  style: TextStyle(
                    decoration: materi['done'] ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        final controller = TextEditingController(text: materi['text']);
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Edit Materi"),
                            content: TextField(controller: controller),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  editMateri(i, controller.text);
                                  Navigator.pop(context);
                                },
                                child: const Text("Simpan"),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteMateri(i),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final controller = TextEditingController();
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Tambah Materi"),
                    content: TextField(controller: controller),
                    actions: [
                      TextButton(
                        onPressed: () {
                          addMateri(controller.text);
                          Navigator.pop(context);
                        },
                        child: const Text("Tambah"),
                      )
                    ],
                  ),
                );
              },
              child: const Text("Tambah Materi"),
            ),
          ],
        ),
      ),
    );
  }
}