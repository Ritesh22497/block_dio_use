import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ─── Section Label ───────────────────────────────────────────────
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 32, height: 1, color: AppColors.accent),
        const SizedBox(width: 12),
        Text(
          text.toUpperCase(),
          style: GoogleFonts.spaceMono(
            fontSize: 11,
            color: AppColors.accent,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

// ─── Section Title ────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Text(
      text,
      style: GoogleFonts.syne(
        fontSize: size > 768 ? 52 : 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02,
        color: AppColors.textPrimary,
        height: 1.1,
      ),
    );
  }
}

// ─── Animated Tag Chip ────────────────────────────────────────────
class TagChip extends StatelessWidget {
  final String label;
  const TagChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.07),
        border: Border.all(color: AppColors.accent.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          fontSize: 10,
          color: AppColors.accent,
          letterSpacing: 0.08,
        ),
      ),
    );
  }
}

// ─── Gradient Divider ─────────────────────────────────────────────
class GradientDivider extends StatelessWidget {
  const GradientDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent2.withOpacity(0.6),
            AppColors.accent.withOpacity(0.6),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// ─── Pulsing Dot ─────────────────────────────────────────────────
class PulsingDot extends StatelessWidget {
  const PulsingDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8, height: 8,
      decoration: const BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .scaleXY(begin: 1, end: 0.6, duration: 1000.ms, curve: Curves.easeInOut)
        .then()
        .scaleXY(begin: 0.6, end: 1, duration: 1000.ms, curve: Curves.easeInOut);
  }
}

// ─── Skill Bar ────────────────────────────────────────────────────
class SkillBar extends StatefulWidget {
  final String name;
  final double percentage;
  final bool animate;

  const SkillBar({
    super.key,
    required this.name,
    required this.percentage,
    this.animate = false,
  });

  @override
  State<SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<SkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    if (widget.animate) _ctrl.forward();
  }

  @override
  void didUpdateWidget(covariant SkillBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pct = (widget.percentage * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.name,
                style: GoogleFonts.dmSans(
                    fontSize: 14, color: AppColors.textPrimary)),
            Text('$pct%',
                style: GoogleFonts.spaceMono(
                    fontSize: 12, color: AppColors.accent)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
          child: AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => FractionallySizedBox(
              widthFactor: _anim.value * widget.percentage,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accent2, AppColors.accent],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ─── Nav Link ─────────────────────────────────────────────────────
class NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const NavLink({super.key, required this.label, required this.onTap});

  @override
  State<NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label.toUpperCase(),
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                color: _hovered ? AppColors.accent : AppColors.textMuted,
                letterSpacing: 0.08,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 1,
              width: _hovered ? 40 : 0,
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}
