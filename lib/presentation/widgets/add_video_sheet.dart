// lib/presentation/widgets/add_video_sheet.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/feed_viewmodel.dart';

class AddVideoSheet extends StatefulWidget {
  const AddVideoSheet({super.key});

  @override
  State<AddVideoSheet> createState() => _AddVideoSheetState();
}

class _AddVideoSheetState extends State<AddVideoSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  final _urlCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _captionCtrl = TextEditingController();

  String _selectedCategory = 'Fun';
  int _selectedColor = 0xFF6C63FF;

  static const _categories = [
    'Fun', 'Travel', 'Food', 'Art', 'Music',
    'Sports', 'Tech', 'Fashion', 'Comedy', 'Other',
  ];

  static const _colors = [
    0xFF6C63FF, 0xFFFF6584, 0xFFFF8C42, 0xFF43C6AC,
    0xFFFFD93D, 0xFF4ECDC4, 0xFFE84393, 0xFF667EEA,
    0xFF2196F3, 0xFFFF5722,
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _urlCtrl.dispose();
    _titleCtrl.dispose();
    _usernameCtrl.dispose();
    _captionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = Color(_selectedColor);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: accent.withOpacity(0.5), width: 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.add_circle_outline, color: accent, size: 22),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Add New Reel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabCtrl,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: accent.withOpacity(0.3),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: accent.withOpacity(0.6)),
              ),
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: const [
                Tab(text: '🔗  URL / Link'),
                Tab(text: '📂  From Device'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tab views
          SizedBox(
            height: 420,
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _buildFormContent(context, isUrlMode: true),
                _buildFormContent(context, isUrlMode: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent(BuildContext context, {required bool isUrlMode}) {
    final accent = Color(_selectedColor);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isUrlMode) ...[
            _buildField(
              controller: _urlCtrl,
              label: 'Video URL',
              hint: 'https://example.com/video.mp4',
              icon: Icons.link,
              accent: accent,
            ),
            const SizedBox(height: 12),
          ],

          _buildField(
            controller: _titleCtrl,
            label: 'Title',
            hint: 'My awesome reel',
            icon: Icons.title,
            accent: accent,
          ),
          const SizedBox(height: 12),

          _buildField(
            controller: _usernameCtrl,
            label: 'Username',
            hint: 'your_username',
            icon: Icons.person_outline,
            accent: accent,
          ),
          const SizedBox(height: 12),

          _buildField(
            controller: _captionCtrl,
            label: 'Caption',
            hint: 'Write something cool... 🔥',
            icon: Icons.comment_outlined,
            accent: accent,
            maxLines: 2,
          ),
          const SizedBox(height: 16),

          // Category picker
          _buildLabel('Category', Icons.category_outlined, accent),
          const SizedBox(height: 8),
          _buildCategoryPicker(accent),
          const SizedBox(height: 16),

          // Color picker
          _buildLabel('Accent Color', Icons.palette_outlined, accent),
          const SizedBox(height: 8),
          _buildColorPicker(),
          const SizedBox(height: 20),

          // Submit button
          Consumer<FeedViewModel>(
            builder: (ctx, vm, _) => SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: vm.isAddingVideo ? null : () => _submit(ctx, vm, isUrlMode),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: accent.withOpacity(0.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: vm.isAddingVideo
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isUrlMode ? Icons.add_link : Icons.upload_file, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            isUrlMode ? 'Add Video' : 'Pick & Add Video',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Consumer<FeedViewModel>(
            builder: (_, vm, __) => vm.addVideoError != null
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade900.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.redAccent, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            vm.addVideoError!,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon, Color accent) {
    return Row(
      children: [
        Icon(icon, color: accent, size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: accent,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color accent,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, icon, accent),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPicker(Color accent) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((cat) {
        final selected = cat == _selectedCategory;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? accent.withOpacity(0.3) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? accent : Colors.white12,
                width: selected ? 1.5 : 0.5,
              ),
            ),
            child: Text(
              cat,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white54,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorPicker() {
    return Wrap(
      spacing: 10,
      children: _colors.map((c) {
        final selected = c == _selectedColor;
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Color(c),
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? Colors.white : Colors.transparent,
                width: selected ? 2.5 : 0,
              ),
              boxShadow: selected
                  ? [BoxShadow(color: Color(c).withOpacity(0.6), blurRadius: 8)]
                  : [],
            ),
            child: selected
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Future<void> _submit(BuildContext ctx, FeedViewModel vm, bool isUrlMode) async {
    bool success;
    if (isUrlMode) {
      if (_urlCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Please enter a video URL'), backgroundColor: Colors.redAccent),
        );
        return;
      }
      success = await vm.addVideoFromUrl(
        url: _urlCtrl.text.trim(),
        title: _titleCtrl.text.trim(),
        username: _usernameCtrl.text.trim(),
        caption: _captionCtrl.text.trim(),
        category: _selectedCategory,
        accentColor: _selectedColor,
      );
    } else {
      success = await vm.addVideoFromFilePicker(
        title: _titleCtrl.text.trim(),
        username: _usernameCtrl.text.trim(),
        caption: _captionCtrl.text.trim(),
        category: _selectedCategory,
        accentColor: _selectedColor,
      );
    }

    if (success && ctx.mounted) {
      Navigator.pop(ctx);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Reel added successfully!'),
            ],
          ),
          backgroundColor: Color(_selectedColor),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}
