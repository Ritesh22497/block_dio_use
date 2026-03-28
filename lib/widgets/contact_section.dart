import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;
    final hPad = isMobile ? 24.0 : 60.0;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Reach Out'),
          const SizedBox(height: 16),
          const SectionTitle("Let's Build Together"),
          const SizedBox(height: 60),
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ContactLinks(),
                    const SizedBox(height: 60),
                    _EducationBlock(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _ContactLinks()),
                    const SizedBox(width: 80),
                    Expanded(child: _EducationBlock()),
                  ],
                ),
        ],
      ),
    );
  }
}

class _ContactLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "I'm currently open to new Flutter development opportunities. Whether you have a project in mind, a role to fill, or just want to connect — I'd love to hear from you.",
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: AppColors.textMuted,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 40),
        _ContactItem(
          icon: '✉️',
          label: 'Email',
          value: 'riteshthakur22497@gmail.com',
          url: 'mailto:riteshthakur22497@gmail.com',
          delay: 0,
        ),
        const SizedBox(height: 12),
        _ContactItem(
          icon: '📱',
          label: 'Phone',
          value: '+91 6387971226',
          url: 'tel:+916387971226',
          delay: 100,
        ),
        const SizedBox(height: 12),
        _ContactItem(
          icon: '💼',
          label: 'LinkedIn',
          value: 'ritesh-sharma-flutte',
          url: 'https://www.linkedin.com/in/ritesh-sharma-flutte',
          delay: 200,
        ),
        const SizedBox(height: 12),
        _ContactItem(
          icon: '🐙',
          label: 'GitHub',
          value: 'Ritesh22497',
          url: 'https://github.com/Ritesh22497',
          delay: 300,
        ),
      ],
    );
  }
}

class _ContactItem extends StatefulWidget {
  final String icon;
  final String label;
  final String value;
  final String url;
  final int delay;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
    required this.delay,
  });

  @override
  State<_ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<_ContactItem> {
  bool _hovered = false;

  Future<void> _launch() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          transform:
              Matrix4.translationValues(_hovered ? 4 : 0, 0, 0),
          decoration: BoxDecoration(
            color: AppColors.card,
            border: Border.all(
              color: _hovered ? AppColors.accent : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.08),
                  border:
                      Border.all(color: AppColors.accent.withOpacity(0.15)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Center(child: Text(widget.icon, style: const TextStyle(fontSize: 16))),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label.toUpperCase(),
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      color: AppColors.textMuted,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.value,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: widget.delay))
        .fadeIn(duration: 500.ms)
        .slideX(begin: -0.1, end: 0);
  }
}

class _EducationBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Education'),
        const SizedBox(height: 24),
        _EduItem(
          degree: 'B.Tech — Computer Science & Engineering',
          school: 'Sagar Institute of Technology & Management, BaraBanki',
          year: 'Aug 2021 — Sep 2024',
          delay: 0,
        ),
        const SizedBox(height: 16),
        _EduItem(
          degree: 'Diploma — Computer Science Engineering',
          school: 'Government Polytechnic, Gonda, Uttar Pradesh',
          year: 'Aug 2017 — Sep 2020',
          delay: 150,
        ),
      ],
    );
  }
}

class _EduItem extends StatelessWidget {
  final String degree;
  final String school;
  final String year;
  final int delay;

  const _EduItem(
      {required this.degree,
      required this.school,
      required this.year,
      required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
     //   borderLeft: const BorderSide(color: AppColors.accent2, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            degree,
            style: GoogleFonts.syne(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(school,
              style: GoogleFonts.dmSans(
                  fontSize: 13, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(
            year,
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              color: AppColors.accent,
              letterSpacing: 0.08,
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.2, end: 0);
  }
}
