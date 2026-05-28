// import 'package:block_dio_use/LIBROLANE/widget/flashcard.dart';
// import 'package:block_dio_use/LIBROLANE/widget/header.dart';
// import 'package:block_dio_use/LIBROLANE/widget/progress_card.dart';
// import 'package:block_dio_use/LIBROLANE/widget/quick_actions.dart';
// import 'package:block_dio_use/LIBROLANE/widget/study_card.dart';
// import 'package:flutter/material.dart';
// import '../utils/colors.dart';


// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: const [
//               Header(),
//               SizedBox(height: 20),
//               StudyCard(),
//               SizedBox(height: 20),
//               QuickActions(),
//               SizedBox(height: 20),
//               FlashCard(),
//               SizedBox(height: 20),
//               ProgressCard(),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: AppColors.primary,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: "AI Chat"),
//           BottomNavigationBarItem(icon: Icon(Icons.book), label: "Flashcards"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.primary,
//         child: const Icon(Icons.add),
//         onPressed: () {},
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "Librolane",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.notifications_none),
                      const SizedBox(width: 12),
                      const CircleAvatar(radius: 18),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// GREETING
              Text(
                "Hey, Rahul 👋",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: "Let's make today "),
                    TextSpan(
                      text: "productive!",
                      style: const TextStyle(color: Color(0xFF6C63FF)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// MAIN CARD (IMPORTANT)
              Container(
                height: 170,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B61FF), Color(0xFF4FC3F7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Continue Studying",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Physics – Motion",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 1),

                    /// Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.6,
                        minHeight: 6,
                        backgroundColor: Colors.white24,
                        color: Colors.white,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Progress",
                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),
                        Text(
                          "60%",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ],
                    ),

                    const SizedBox(height: 1),

                    /// Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Resume Study",
                        style: GoogleFonts.poppins(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// QUICK ACTIONS (PIXEL PERFECT GRID)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _action("Doubt Snap", Icons.camera_alt),
                  _action("Record", Icons.mic),
                  _action("Planner", Icons.calendar_month),
                  _action("Vault", Icons.folder),
                ],
              ),

              const SizedBox(height: 25),

              /// FLASHCARD
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E5A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's Flashcard",
                        style: GoogleFonts.poppins(
                            color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 10),
                    Text(
                      "What is Newton’s Second Law of Motion?",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      /// BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "AI Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Flashcards"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),

      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF7B61FF), Color(0xFF4FC3F7)],
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _action(String title, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.05),
              )
            ],
          ),
          child: Icon(icon, color: Color(0xFF6C63FF)),
        ),
        const SizedBox(height: 8),
        Text(title, style: GoogleFonts.poppins(fontSize: 12)),
      ],
    );
  }
}