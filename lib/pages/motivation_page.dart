import 'package:flutter/material.dart';
import 'dart:math';

class MotivationPage extends StatefulWidget {
  const MotivationPage({super.key});

  @override
  State<MotivationPage> createState() => _MotivationPageState();
}

class _MotivationPageState extends State<MotivationPage> {
  final List<String> allMotivations = const [
    "Belajar hari ini adalah investasi masa depanmu.",
    "Sedikit demi sedikit, lama-lama menjadi bukit!",
    "Fokuslah pada proses, bukan hasil.",
    "Istirahat itu penting, tapi jangan lupa kembali belajar.",
    "Satu jam belajarmu hari ini akan sangat berarti esok.",
    "Setiap detik belajar mendekatkanmu pada impian.",
    "Kesuksesan dimulai dari tekad untuk terus mencoba.",
    "Ilmu adalah kunci menuju pintu masa depan.",
    "Kegigihan hari ini akan menjadi kebanggaan esok.",
    "Rasa malas hanya bisa dikalahkan oleh tujuan besar."
  ];

  List<String> displayedMotivations = [];

  @override
  void initState() {
    super.initState();
    _generateMotivations();
  }

  void _generateMotivations() {
    final random = Random();
    final temp = List<String>.from(allMotivations)..shuffle(random);
    setState(() {
      displayedMotivations = temp.take(3).toList(); // tampilkan 3 motivasi acak
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9EC),
      appBar: AppBar(
        title: const Text("Motivasi Harian"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.emoji_objects, size: 60, color: Colors.orangeAccent),
            const SizedBox(height: 10),
            const Text(
              "Kutipan Semangat untukmu!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: displayedMotivations.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        displayedMotivations[index],
                        style: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _generateMotivations,
                icon: const Icon(Icons.refresh),
                label: const Text("Muat Ulang Motivasi"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}