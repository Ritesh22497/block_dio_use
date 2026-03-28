import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;
    final hPad = isMobile ? 24.0 : 60.0;

    return VisibilityDetector(
      key: const Key('skills-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        color: AppColors.bg,
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel('Expertise'),
            const SizedBox(height: 16),
            const SectionTitle('Skills & Strengths'),
            const SizedBox(height: 60),
            isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkillBars(visible: _visible),
                      const SizedBox(height: 40),
                      _StrengthCards(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _SkillBars(visible: _visible)),
                      const SizedBox(width: 80),
                      Expanded(child: _StrengthCards()),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _SkillBars extends StatelessWidget {
  final bool visible;
  const _SkillBars({required this.visible});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkillGroup(
          title: 'Core Technologies',
          skills: PortfolioData.coreSkills,
          visible: visible,
        ),
        const SizedBox(height: 16),
        _SkillGroup(
          title: 'Additional Skills',
          skills: PortfolioData.additionalSkills,
          visible: visible,
        ),
      ],
    );
  }
}

class _SkillGroup extends StatelessWidget {
  final String title;
  final List<Skill> skills;
  final bool visible;

  const _SkillGroup(
      {required this.title, required this.skills, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.spaceMono(
            fontSize: 11,
            color: AppColors.textMuted,
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 4),
        const Divider(color: AppColors.border),
        const SizedBox(height: 16),
        ...skills.map(
          (s) => SkillBar(
              name: s.name, percentage: s.percentage, animate: visible),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _StrengthCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      ('⏰', 'Time Punctual',
          'Dedicated and punctual in all professional engagements — deadlines are commitments, not suggestions.'),
      ('⚡', 'Works Under Pressure',
          'Proven ability to deliver quality work under tight deadlines without compromising on code quality.'),
      ('🤝', 'Respectful Collaborator',
          'Professional and respectful in all interactions, fostering a positive and productive team environment.'),
    ];

    return Column(
      children: items
          .asMap()
          .entries
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _StrengthCard(
                icon: e.value.$1,
                title: e.value.$2,
                desc: e.value.$3,
                delay: e.key * 120,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _StrengthCard extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;
  final int delay;

  const _StrengthCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.syne(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 600.ms)
        .slideX(begin: 0.1, end: 0);
  }
}
