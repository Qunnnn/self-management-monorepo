import 'package:mobile/core/import/app_imports.dart';

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
    final entries = await ref.read(diaryProvider.future);
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
        await ref.read(diaryProvider.notifier).updateEntry(updated);
      } else {
        final entry = DiaryEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: _contentController.text.trim(),
          mood: _selectedMood,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await ref.read(diaryProvider.notifier).createEntry(entry);
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
                await ref.read(diaryProvider.notifier).deleteEntry(widget.entryId!);
                navigator.pop();
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _titleController,
              label: 'Title',
              hintText: 'What happened today?',
              autofocus: widget.entryId == null,
            ),
            24.h,
            Text(
              'HOW ARE YOU FEELING?',
              style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    color: AppColors.warmGray500,
                  ),
            ),
            12.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: DiaryMood.values.map((mood) {
                final isSelected = _selectedMood == mood;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = mood),
                  child: Container(
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
                        4.h,
                        Text(
                          mood.displayName,
                          style: context.textTheme.bodySmall?.copyWith(
                                color: isSelected ? AppColors.blue : AppColors.warmGray500,
                                fontWeight: isSelected ? FontWeight.bold : null,
                              ),
                        ),
                      ],
                    ).p(12),
                  ),
                );
              }).toList(),
            ),
            24.h,
            AppTextField(
              controller: _contentController,
              label: 'Notes',
              hintText: 'Write down your thoughts...',
              maxLines: 10,
            ),
            40.h,
            AppButton(
              text: 'Save Entry',
              isLoading: _isLoading,
              onPressed: _save,
            ),
          ],
        ).p(24),
      ),
    );
  }
}
