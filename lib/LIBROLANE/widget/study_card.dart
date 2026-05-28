import 'package:flutter/material.dart';
import '../utils/colors.dart';

class StudyCard extends StatelessWidget {
  const StudyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.gradient1],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Physics - Motion",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          const LinearProgressIndicator(
            value: 0.6,
            backgroundColor: Colors.white24,
            color: Colors.white,
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
            ),
            onPressed: () {},
            child: const Text("Resume Study"),
          )
        ],
      ),
    );
  }
}