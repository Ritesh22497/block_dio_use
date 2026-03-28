import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';

class TechScrollBar extends StatefulWidget {
  const TechScrollBar({super.key});

  @override
  State<TechScrollBar> createState() => _TechScrollBarState();
}

class _TechScrollBarState extends State<TechScrollBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late ScrollController _scrollCtrl;
  double _offset = 0;
  static const double _itemWidth = 180;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..addListener(() {
        final total = PortfolioData.techStack.length * _itemWidth;
        _offset = _ctrl.value * total;
        if (_scrollCtrl.hasClients) {
          _scrollCtrl.jumpTo(_offset % total);
        }
      });
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      ...PortfolioData.techStack,
      ...PortfolioData.techStack,
      ...PortfolioData.techStack,
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.border),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
        controller: _scrollCtrl,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: items
              .map(
                (t) => SizedBox(
                  width: _itemWidth,
                  child: Row(
                    children: [
                      Text(
                        '◆',
                        style: TextStyle(
                            color: AppColors.accent, fontSize: 8),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        t.toUpperCase(),
                        style: GoogleFonts.spaceMono(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          letterSpacing: 0.12,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
