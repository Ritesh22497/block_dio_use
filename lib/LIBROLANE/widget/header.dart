import 'package:flutter/material.dart';
import '../utils/colors.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Hey, Rahul 👋", style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            Text(
              "Let's make today productive!",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(
              "https://i.pravatar.cc/300"),
        )
      ],
    );
  }
}