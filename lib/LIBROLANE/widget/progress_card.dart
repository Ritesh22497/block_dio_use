import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text("2/5"),
              Text("Tasks"),
            ],
          ),
          Column(
            children: [
              Text("40"),
              Text("XP"),
            ],
          ),
          Column(
            children: [
              Text("Level 3"),
              Text("Keep Going"),
            ],
          ),
        ],
      ),
    );
  }
}