// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Quản lý bản thân';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonError => 'Lỗi';

  @override
  String get commonSuccess => 'Thành công';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsTheme => 'Giao diện';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get themeSystem => 'Hệ thống';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get languageSystem => 'Theo hệ thống';

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get authForgotPassword => 'Quên mật khẩu';

  @override
  String get authResetLinkSent => 'Đã gửi liên kết đặt lại mật khẩu!';

  @override
  String get authEmail => 'Email';

  @override
  String get authEmailHint => 'Nhập email của bạn';

  @override
  String get authPassword => 'Mật khẩu';

  @override
  String get authPasswordHint => 'Nhập mật khẩu của bạn';

  @override
  String get tasksTitle => 'Tiêu đề';

  @override
  String get tasksTitleHint => 'Việc cần làm là gì?';

  @override
  String get tasksDescription => 'Mô tả';

  @override
  String get tasksDescriptionHint => 'Chi tiết tùy chọn';

  @override
  String get financeTitle => 'Tài chính';

  @override
  String get financeAdd => 'Thêm';

  @override
  String get financeNoTransactions => 'Chưa có giao dịch nào';

  @override
  String get financeExpense => 'Chi phí';

  @override
  String get financeIncome => 'Thu nhập';

  @override
  String get financeTransactionTitle => 'Tiêu đề';

  @override
  String get financeTransactionTitleHint => 'Khoản này dành cho việc gì?';

  @override
  String get financeAmount => 'Số tiền';

  @override
  String get financeAmountHint => '0.00';

  @override
  String get financeCategory => 'Danh mục';

  @override
  String get financeCategoryHint => 'ví dụ: Thức ăn, Công việc';

  @override
  String get diaryTitle => 'Nhật ký';

  @override
  String get diarySearchHint => 'Tìm kiếm mục...';

  @override
  String get diaryNoEntries => 'Không tìm thấy mục nào';

  @override
  String get diaryEditEntry => 'Chỉnh sửa mục';

  @override
  String get diaryNewEntry => 'Mục mới';

  @override
  String get diaryEntryTitle => 'Tiêu đề';

  @override
  String get diaryEntryTitleHint => 'Hôm nay có chuyện gì xảy ra?';

  @override
  String get diaryNotes => 'Ghi chú';

  @override
  String get diaryNotesHint => 'Viết ra những suy nghĩ của bạn...';

  @override
  String commonErrorPrefix(String message) {
    return 'Lỗi: $message';
  }

  @override
  String commonErrorLoading(String message) {
    return 'Lỗi khi tải: $message';
  }

  @override
  String get authWelcomeBack => 'Chào mừng trở lại';

  @override
  String get authLoginPrompt => 'Đăng nhập vào tài khoản của bạn';

  @override
  String get authLogin => 'Đăng nhập';

  @override
  String get authSendResetLink => 'Gửi liên kết đặt lại';

  @override
  String get authEnterEmailPrompt =>
      'Nhập email của bạn và chúng tôi sẽ gửi cho bạn liên kết đặt lại.';

  @override
  String get tasksNewTask => 'Nhiệm vụ mới';

  @override
  String get tasksCreateTask => 'Tạo nhiệm vụ';

  @override
  String get financeRecentTransactions => 'GIAO DỊCH GẦN ĐÂY';

  @override
  String get financeAddTransaction => 'Thêm giao dịch';

  @override
  String get financeSaveTransaction => 'Lưu giao dịch';

  @override
  String get diaryHowAreYouFeeling => 'BẠN ĐANG CẢM THẤY THẾ NÀO?';

  @override
  String get diarySaveEntry => 'Lưu mục nhật ký';
}
