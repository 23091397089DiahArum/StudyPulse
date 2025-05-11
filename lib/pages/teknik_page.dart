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

  String _getDescription(TimerMode mode) {
    switch (mode) {
      case TimerMode.pomodoro:
        return "25 menit fokus, 5 menit istirahat";
      case TimerMode.rule_5217:
        return "52 menit kerja, 17 menit istirahat";
      case TimerMode.ultradian_rhythm:
        return "90 menit kerja, 20 menit istirahat";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FC), // biru muda sebagai background
      appBar: AppBar(
        title: const Text("Pilih Teknik Belajar"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: TimerMode.values.map((mode) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PomodoroTimerPage(selectedMode: mode),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        _getIconForMode(mode),
                        size: 28,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mode.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getDescription(mode),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}