// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'فين تراك';

  @override
  String get addTransactionTitle => 'إضافة معاملة';

  @override
  String get editTransactionTitle => 'تعديل المعاملة';

  @override
  String get amountLabel => 'المبلغ (درهم)';

  @override
  String get categoryLabel => 'الفئة (مثل الطعام، التاكسي)';

  @override
  String get noteLabel => 'ملاحظة (اختياري)';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get pickDateButton => 'اختر التاريخ';

  @override
  String get expense => 'المصروفات';

  @override
  String get income => 'الدخل';

  @override
  String get saveButton => 'حفظ';

  @override
  String get updateButton => 'تحديث';

  @override
  String get addButton => 'إضافة';

  @override
  String get themeMenu => 'وضع السمة';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'النظام';

  @override
  String get noTransactions => 'لا توجد معاملات بعد';

  @override
  String get addFirstTransaction => 'اضغط على زر الإضافة لتسجيل أول مصروف أو دخل.';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'المصروف';

  @override
  String get remaining => 'المتبقي';

  @override
  String get setBudget => 'تعيين الميزانية';

  @override
  String get editBudget => 'تعديل الميزانية';

  @override
  String get budgetSet => 'تم تعيين الميزانية لهذا الشهر';

  @override
  String get noBudgetSet => 'لم يتم تعيين ميزانية بعد';

  @override
  String get grandTotal => 'الإجمالي';

  @override
  String get delete => 'حذف';

  @override
  String get amountError => 'أدخل المبلغ';

  @override
  String get positiveAmountError => 'أدخل مبلغًا صحيحًا وإيجابيًا';

  @override
  String get categoryError => 'أدخل الفئة';

  @override
  String get note => 'ملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get typeYourNote => 'اكتب ملاحظتك هنا...';

  @override
  String get clear => 'مسح';

  @override
  String get close => 'إغلاق';

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get edit => 'تعديل';
}
