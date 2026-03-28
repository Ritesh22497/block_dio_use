import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

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
          const SectionLabel('Career'),
          const SizedBox(height: 16),
          const SectionTitle('Work Experience'),
          const SizedBox(height: 60),
          ...PortfolioData.experiences.asMap().entries.map(
                (e) => _ExperienceItem(
                  exp: e.value,
                  isMobile: isMobile,
                  delay: e.key * 120,
                ),
              ),
        ],
      ),
    );
  }
}

class _ExperienceItem extends StatefulWidget {
  final Experience exp;
  final bool isMobile;
  final int delay;

  const _ExperienceItem({
    required this.exp,
    required this.isMobile,
    required this.delay,
  });

  @override
  State<_ExperienceItem> createState() => _ExperienceItemState();
}

class _ExperienceItemState extends State<_ExperienceItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.only(
          left: _hovered ? 20 : 0,
          top: 40,
          bottom: 40,
        ),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: widget.isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DateLabel(widget.exp.period),
                  const SizedBox(height: 12),
                  _ExpContent(widget.exp),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: _DateLabel(widget.exp.period),
                  ),
                  const SizedBox(width: 40),
                  Expanded(child: _ExpContent(widget.exp)),
                ],
              ),
      ),
    )
        .animate(delay: Duration(milliseconds: widget.delay))
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

class _DateLabel extends StatelessWidget {
  final String date;
  const _DateLabel(this.date);

  @override
  Widget build(BuildContext context) {
    return Text(
      date,
      style: GoogleFonts.spaceMono(
        fontSize: 12,
        color: AppColors.textMuted,
        letterSpacing: 0.05,
      ),
    );
  }
}

class _ExpContent extends StatelessWidget {
  final Experience exp;
  const _ExpContent(this.exp);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exp.company,
          style: GoogleFonts.syne(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          exp.role,
          style: GoogleFonts.spaceMono(
            fontSize: 14,
            color: AppColors.accent,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          exp.description,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: AppColors.textMuted,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}
