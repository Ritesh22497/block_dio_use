import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;
    final hPad = isMobile ? 24.0 : 60.0;

    return Container(
      color: AppColors.bg,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Work'),
          const SizedBox(height: 16),
          const SectionTitle('Featured Projects'),
          const SizedBox(height: 60),
          _ProjectsGrid(isMobile: isMobile),
        ],
      ),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  final bool isMobile;
  const _ProjectsGrid({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: PortfolioData.projects
            .asMap()
            .entries
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _ProjectCard(project: e.value, delay: e.key * 100),
                ))
            .toList(),
      );
    }

    final rows = <Widget>[];
    for (int i = 0; i < PortfolioData.projects.length; i += 2) {
      final hasNext = i + 1 < PortfolioData.projects.length;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: _ProjectCard(
                      project: PortfolioData.projects[i], delay: i * 100)),
              const SizedBox(width: 20),
              if (hasNext)
                Expanded(
                    child: _ProjectCard(
                        project: PortfolioData.projects[i + 1],
                        delay: (i + 1) * 100))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _ProjectCard extends StatefulWidget {
  final Project project;
  final int delay;

  const _ProjectCard({required this.project, required this.delay});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(32),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withOpacity(0.2)
                : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 60,
                    offset: const Offset(0, 20),
                  )
                ]
              : [],
        ),
        child: Stack(
          children: [
            // Top gradient line
            Positioned(
              top: -32,
              left: -32,
              right: -32,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accent2, AppColors.accent],
                  ),
                ),
                transform: (Matrix4.identity()..scale(_hovered ? 1.0 : 0.0, 1.0, 1.0)),
                transformAlignment: Alignment.centerLeft,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.project.number} — ${widget.project.linkLabel}',
                  style: GoogleFonts.spaceMono(
                    fontSize: 11,
                    color: AppColors.accent.withOpacity(0.6),
                    letterSpacing: 0.15,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.project.title,
                  style: GoogleFonts.syne(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.project.description,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.textMuted,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      widget.project.tags.map((t) => TagChip(t)).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'View Project',
                      style: GoogleFonts.spaceMono(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        letterSpacing: 0.1,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(left: _hovered ? 12 : 8),
                      child: Text(
                        '→',
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          color: _hovered
                              ? AppColors.accent
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: widget.delay))
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }
}
