import 'package:flutter/material.dart';
import 'package:studypulse/utils/timer_mode.dart';
import 'timer_page.dart';

class TeknikPage extends StatelessWidget {
  const TeknikPage({super.key});

  IconData _getIconForMode(TimerMode mode) {
    switch (mode) {
      case TimerMode.pomodoro:
        return Icons.timer;
      case TimerMode.rule_5217:
        return Icons.schedule;
      case TimerMode.ultradian_rhythm:
        return Icons.bolt;
      default:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Teknik Belajar"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: TimerMode.values.map((mode) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: Icon(_getIconForMode(mode), color: Colors.deepPurple),
              title: Text(
                mode.name.toUpperCase(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PomodoroTimerPage(selectedMode: mode),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}