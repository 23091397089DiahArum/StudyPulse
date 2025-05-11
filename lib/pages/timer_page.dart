import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/timer_mode.dart';
import '../models/materi.dart';
import '../widgets/materi_list.dart';

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

  List<Materi> materiList = [];

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
    loadMateriList();
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

  Future<void> saveMateriList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = materiList.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('materiList', jsonList);
  }

  Future<void> loadMateriList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('materiList') ?? [];
    setState(() {
      materiList = jsonList.map((e) => Materi.fromJson(json.decode(e))).toList();
    });
  }

  void addMateri(String text) {
    setState(() {
      materiList.add(Materi(text: text));
    });
    saveMateriList();
  }

  void editMateri(int index, String newText) {
    setState(() {
      materiList[index].text = newText;
    });
    saveMateriList();
  }

  void toggleCentang(int index) {
    setState(() {
      materiList[index].isChecked = !materiList[index].isChecked;
    });
    saveMateriList();
  }

  void deleteMateri(int index) {
    setState(() {
      materiList.removeAt(index);
    });
    saveMateriList();
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
            MateriList(
              materiList: materiList,
              onDelete: deleteMateri,
              onEdit: editMateri,
              onToggleCheck: (i, checked) => toggleCentang(i),
            ),
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