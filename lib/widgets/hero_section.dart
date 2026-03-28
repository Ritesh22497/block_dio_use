import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onViewProjects;
  final VoidCallback onContact;

  const HeroSection({
    super.key,
    required this.onViewProjects,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;
    final hPad = isMobile ? 24.0 : 60.0;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 700),
      padding: EdgeInsets.fromLTRB(hPad, isMobile ? 100 : 140, hPad, 80),
      decoration: BoxDecoration(
        color: AppColors.bg,
        gradient: RadialGradient(
          center: const Alignment(0.8, 0),
          radius: 1.2,
          colors: [
            AppColors.accent.withOpacity(0.05),
            AppColors.bg,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Grid background
          Positioned.fill(child: _GridBackground()),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Available tag
              _AvailableTag()
                  .animate()
                  .fadeIn(duration: 700.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 32),

              // Name + Title
              RichText(
                text: TextSpan(
                  style: GoogleFonts.syne(
                    fontSize: isMobile ? 52 : 88,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.03,
                    height: 0.95,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Ritesh ',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    const TextSpan(
                      text: 'Sharma\n',
                      style: TextStyle(color: AppColors.accent),
                    ),
                    WidgetSpan(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppColors.accent2, AppColors.accent],
                        ).createShader(bounds),
                        child: Text(
                          'Flutter Developer',
                          style: GoogleFonts.syne(
                            fontSize: isMobile ? 52 : 88,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.03,
                            height: 0.95,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: 150.ms)
                  .fadeIn(duration: 700.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 28),

              // Description
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  'Building cross-platform mobile experiences with precision and care. 2+ years shipping production apps with 100,000+ combined downloads on Google Play.',
                  style: GoogleFonts.dmSans(
                    fontSize: 17,
                    height: 1.7,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 700.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 44),

              // Stats
              _StatsRow(isMobile: isMobile)
                  .animate(delay: 450.ms)
                  .fadeIn(duration: 700.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 48),

              // Buttons
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  _PrimaryButton(
                    label: 'View Projects →',
                    onTap: onViewProjects,
                  ),
                  _GhostButton(
                    label: 'Get In Touch',
                    onTap: onContact,
                  ),
                ],
              )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 700.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridPainter());
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;
    const step = 60.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _AvailableTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.08),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PulsingDot(),
          const SizedBox(width: 10),
          Text(
            'Available for new opportunities',
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              color: AppColors.accent,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final bool isMobile;
  const _StatsRow({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: isMobile ? 28 : 48,
      runSpacing: 16,
      children: const [
        _StatItem(num: '2+', label: 'Years Experience'),
        _StatItem(num: '10+', label: 'Apps Shipped'),
        _StatItem(num: '100K+', label: 'Downloads'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String num;
  final String label;
  const _StatItem({required this.num, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [AppColors.textPrimary, AppColors.accent],
          ).createShader(b),
          child: Text(
            num,
            style: GoogleFonts.syne(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.spaceMono(
            fontSize: 11,
            color: AppColors.textMuted,
            letterSpacing: 0.05,
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(4),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.3),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
          child: Text(
            widget.label,
            style: GoogleFonts.spaceMono(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              letterSpacing: 0.05,
            ),
          ),
        ),
      ),
    );
  }
}

class _GhostButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GhostButton({required this.label, required this.onTap});

  @override
  State<_GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<_GhostButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: _hovered ? AppColors.accent : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.spaceMono(
              fontSize: 13,
              color: _hovered ? AppColors.accent : AppColors.textPrimary,
              letterSpacing: 0.05,
            ),
          ),
        ),
      ),
    );
  }
}
