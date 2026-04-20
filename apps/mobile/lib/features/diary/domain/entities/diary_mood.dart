enum DiaryMood {
  happy,
  productive,
  tired,
  neutral;

  String get displayName {
    switch (this) {
      case DiaryMood.happy:
        return 'Happy';
      case DiaryMood.productive:
        return 'Productive';
      case DiaryMood.tired:
        return 'Tired';
      case DiaryMood.neutral:
        return 'Neutral';
    }
  }

  String get emoji {
    switch (this) {
      case DiaryMood.happy:
        return '😊';
      case DiaryMood.productive:
        return '🚀';
      case DiaryMood.tired:
        return '😴';
      case DiaryMood.neutral:
        return '😐';
    }
  }
}
