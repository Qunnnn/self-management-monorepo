import 'package:mobile/core/import/app_imports.dart';

class DiaryEntryPage extends ConsumerStatefulWidget {
  final String? entryId;

  const DiaryEntryPage({super.key, this.entryId});

  @override
  ConsumerState<DiaryEntryPage> createState() => _DiaryEntryPageState();
}

class _DiaryEntryPageState extends ConsumerState<DiaryEntryPage> {
  late FormGroup form;
  bool _isLoading = false;
  DiaryEntry? _existingEntry;

  @override
  void initState() {
    super.initState();
    form = fb.group({
      'title': ['', Validators.required],
      'content': [''],
      'mood': [null as DiaryMood?],
    });

    if (widget.entryId != null) {
      _loadExistingEntry();
    }
  }

  Future<void> _loadExistingEntry() async {
    final entries = await ref.read(diaryProvider.future);
    _existingEntry = entries.firstWhere((e) => e.id == widget.entryId);
    if (_existingEntry != null) {
      form.patchValue({
        'title': _existingEntry!.title,
        'content': _existingEntry!.content,
        'mood': _existingEntry!.mood,
      });
    }
  }

  Future<void> _save() async {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    setState(() => _isLoading = true);
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final values = form.value;
      final title = values['title'] as String;

      if (_existingEntry != null) {
        final updated = _existingEntry!.copyWith(
          title: title,
          content: values['content'] as String,
          mood: values['mood'] as DiaryMood?,
          updatedAt: DateTime.now(),
        );
        await ref.read(diaryProvider.notifier).updateEntry(updated);
      } else {
        final entry = DiaryEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: values['content'] as String,
          mood: values['mood'] as DiaryMood?,
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
      body: ReactiveForm(
        formGroup: form,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReactiveAppTextField<String>(
                formControlName: 'title',
                label: 'Title',
                hintText: 'What happened today?',
                autofocus: widget.entryId == null,
                validationMessages: {
                  ValidationMessage.required: (_) => 'Title is required',
                },
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
              ReactiveValueListenableBuilder<DiaryMood>(
                formControlName: 'mood',
                builder: (context, control, child) {
                  final selectedMood = control.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: DiaryMood.values.map((mood) {
                      final isSelected = selectedMood == mood;
                      return GestureDetector(
                        onTap: () => control.value = mood,
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
                  );
                },
              ),
              24.h,
              ReactiveAppTextField<String>(
                formControlName: 'content',
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
      ),
    );
  }
}
