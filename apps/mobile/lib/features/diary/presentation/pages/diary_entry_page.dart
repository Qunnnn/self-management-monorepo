import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/diary_entry.dart';
import '../../domain/entities/diary_mood.dart';
import '../providers/diary_provider.dart';

class DiaryEntryPage extends ConsumerStatefulWidget {
  final String? entryId;

  const DiaryEntryPage({super.key, this.entryId});

  @override
  ConsumerState<DiaryEntryPage> createState() => _DiaryEntryPageState();
}

class _DiaryEntryPageState extends ConsumerState<DiaryEntryPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  DiaryMood? _selectedMood;
  bool _isLoading = false;
  DiaryEntry? _existingEntry;

  @override
  void initState() {
    super.initState();
    if (widget.entryId != null) {
      _loadExistingEntry();
    }
  }

  Future<void> _loadExistingEntry() async {
    final entries = await ref.read(diaryNotifierProvider.future);
    _existingEntry = entries.firstWhere((e) => e.id == widget.entryId);
    if (_existingEntry != null) {
      _titleController.text = _existingEntry!.title;
      _contentController.text = _existingEntry!.content;
      setState(() {
        _selectedMood = _existingEntry!.mood;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _isLoading = true);
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      if (_existingEntry != null) {
        final updated = _existingEntry!.copyWith(
          title: title,
          content: _contentController.text.trim(),
          mood: _selectedMood,
          updatedAt: DateTime.now(),
        );
        await ref.read(diaryNotifierProvider.notifier).updateEntry(updated);
      } else {
        final entry = DiaryEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: _contentController.text.trim(),
          mood: _selectedMood,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await ref.read(diaryNotifierProvider.notifier).createEntry(entry);
      }
      navigator.pop();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error saving entry: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(widget.entryId != null ? 'Edit Entry' : 'New Entry'),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          if (widget.entryId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.orange),
              onPressed: () async {
                final navigator = Navigator.of(context);
                await ref.read(diaryNotifierProvider.notifier).deleteEntry(widget.entryId!);
                navigator.pop();
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _titleController,
              label: 'Title',
              hintText: 'What happened today?',
              autofocus: widget.entryId == null,
            ),
            const SizedBox(height: 24),
            Text(
              'HOW ARE YOU FEELING?',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    color: AppColors.warmGray500,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: DiaryMood.values.map((mood) {
                final isSelected = _selectedMood == mood;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = mood),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.blue.withAlpha(20) : AppColors.warmWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.blue : AppColors.whisperBorder,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(mood.emoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 4),
                        Text(
                          mood.displayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isSelected ? AppColors.blue : AppColors.warmGray500,
                                fontWeight: isSelected ? FontWeight.bold : null,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: _contentController,
              label: 'Notes',
              hintText: 'Write down your thoughts...',
              maxLines: 10,
            ),
            const SizedBox(height: 40),
            AppButton(
              text: 'Save Entry',
              isLoading: _isLoading,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
