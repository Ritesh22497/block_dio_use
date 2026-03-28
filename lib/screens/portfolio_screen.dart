import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/hero_section.dart';
import '../widgets/tech_scroll_bar.dart';
import '../widgets/experience_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/contact_section.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final _scrollCtrl = ScrollController();
  final _projectsKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _contactKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollCtrl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top nav spacer
                const SizedBox(height: 0),

                // Hero
                HeroSection(
                  onViewProjects: () => _scrollTo(_projectsKey),
                  onContact: () => _scrollTo(_contactKey),
                ),

                // Tech bar
                const TechScrollBar(),

                // Experience
                Container(key: _experienceKey),
                const ExperienceSection(),

                // Projects
                Container(key: _projectsKey),
                const ProjectsSection(),

                // Skills
                Container(key: _skillsKey),
                const SkillsSection(),

                // Contact
                Container(key: _contactKey),
                const ContactSection(),

                // Footer
                _Footer(),
              ],
            ),
          ),

          // Nav overlay
          _NavBar(
            isMobile: isMobile,
            onExperience: () => _scrollTo(_experienceKey),
            onProjects: () => _scrollTo(_projectsKey),
            onSkills: () => _scrollTo(_skillsKey),
            onContact: () => _scrollTo(_contactKey),
          ),
        ],
      ),
    );
  }
}

// ─── Navigation Bar ───────────────────────────────────────────────
class _NavBar extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onExperience;
  final VoidCallback onProjects;
  final VoidCallback onSkills;
  final VoidCallback onContact;

  const _NavBar({
    required this.isMobile,
    required this.onExperience,
    required this.onProjects,
    required this.onSkills,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: ClipRect(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 60,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: AppColors.bg.withOpacity(0.85),
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RS_',
                style: GoogleFonts.spaceMono(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                  letterSpacing: -0.5,
                ),
              ),
              if (!isMobile)
                Row(
                  children: [
                    NavLink(label: 'Experience', onTap: onExperience),
                    const SizedBox(width: 36),
                    NavLink(label: 'Projects', onTap: onProjects),
                    const SizedBox(width: 36),
                    NavLink(label: 'Skills', onTap: onSkills),
                    const SizedBox(width: 36),
                    NavLink(label: 'Contact', onTap: onContact),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 60,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_copyText(), const SizedBox(height: 8), _madeText()],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_copyText(), _madeText()],
            ),
    );
  }

  Widget _copyText() => Text(
        '© 2025 Ritesh Sharma. All rights reserved.',
        style: GoogleFonts.spaceMono(fontSize: 12, color: AppColors.textMuted),
      );

  Widget _madeText() => RichText(
        text: TextSpan(
          style: GoogleFonts.spaceMono(fontSize: 12, color: AppColors.textMuted),
          children: [
            const TextSpan(text: 'Built with '),
            const TextSpan(
                text: '♥', style: TextStyle(color: AppColors.accent)),
            const TextSpan(text: ' & Flutter spirit — Lucknow, UP'),
          ],
        ),
      );
}
