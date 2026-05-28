import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        ActionItem(icon: Icons.camera_alt, title: "Doubt Snap"),
        ActionItem(icon: Icons.mic, title: "Record"),
        ActionItem(icon: Icons.calendar_month, title: "Planner"),
        ActionItem(icon: Icons.folder, title: "Vault"),
      ],
    );
  }
}

class ActionItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const ActionItem({required this.icon, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: Colors.deepPurple),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12))
      ],
    );
  }
}