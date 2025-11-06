// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'فينتراك';

  @override
  String get addTransactionTitle => 'إضافة معاملة';

  @override
  String get editTransactionTitle => 'تعديل المعاملة';

  @override
  String get amountLabel => 'المبلغ (درهم)';

  @override
  String get categoryLabel => 'الفئة (مثل: طعام، تاكسي)';

  @override
  String get noteLabel => 'ملاحظة (اختياري)';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get pickDateButton => 'اختر التاريخ';

  @override
  String get expense => 'مصروف';

  @override
  String get income => 'دخل';

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
  String get noTransactions => 'لا توجد معاملات حتى الآن';

  @override
  String get addFirstTransaction => 'اضغط على زر إضافة لتسجيل أول مصروف أو دخل لك.';

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
  String get positiveAmountError => 'أدخل مبلغًا موجبًا صحيحًا';

  @override
  String get categoryError => 'أدخل فئة';

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

  @override
  String get todayLabel => 'اليوم';

  @override
  String get yesterdayLabel => 'أمس';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get insightsTitle => 'التحليلات والإحصاءات';

  @override
  String get monthSelectorThisMonth => 'هذا الشهر';

  @override
  String get prevMonth => 'السابق';

  @override
  String get nextMonth => 'التالي';

  @override
  String get net => 'الصافي';

  @override
  String get byCategory => 'حسب الفئة';

  @override
  String get dailyExpenseTrend => 'اتجاه المصروف اليومي';

  @override
  String get topCategories => 'أعلى الفئات';

  @override
  String get noExpenses => 'لا توجد مصروفات هذا الشهر';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get byNavas => 'بواسطة محمد نواس';

  @override
  String get analytics => 'التحليلات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get security => 'الأمان';

  @override
  String get about => 'حول التطبيق';

  @override
  String get changePin => 'تغيير رقم التعريف الشخصي';

  @override
  String get displayCurrency => 'العملة المعروضة';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get rateApp => 'قيّم التطبيق';

  @override
  String get currencyAed => 'درهم إماراتي';

  @override
  String get currencyInr => 'روبية هندية';

  @override
  String get currencyUsd => 'دولار أمريكي';

  @override
  String get currencyEur => 'يورو';

  @override
  String get currencySar => 'ريال سعودي';

  @override
  String get currencyQar => 'ريال قطري';

  @override
  String get currencyOmr => 'ريال عماني';

  @override
  String displayCurrencyUpdated(Object currency, Object time) {
    return 'تم التحويل إلى $currency · تم التحديث $time';
  }

  @override
  String get currencyConversionUnavailable => 'التحويل غير متاح. يتم عرض العملة الأصلية.';

  @override
  String get setPinTitle => 'تعيين رقم التعريف الشخصي';

  @override
  String get setPinSubtitle => 'قم بتأمين التطبيق باستخدام رقم التعريف الشخصي';

  @override
  String get setPinDescription => 'أنشئ رقم تعريف شخصي مكون من 4 إلى 6 أرقام لحماية التطبيق.';

  @override
  String get confirmPin => 'تأكيد الرقم';

  @override
  String get enterPin => 'أدخل الرقم';

  @override
  String get incorrectPin => 'الرقم غير صحيح';

  @override
  String get pinNotMatch => 'الرقمان غير متطابقين';

  @override
  String get pinTooShort => 'يجب أن يتكون الرقم من 4 أرقام على الأقل';

  @override
  String get pinHelper => '6 أرقام';

  @override
  String get savePin => 'حفظ الرقم';

  @override
  String get unlockTitle => 'فتح القفل';

  @override
  String get unlockSubtitle => 'أدخل رقم التعريف الشخصي المكون من 6 أرقام';

  @override
  String get unlockButton => 'فتح';

  @override
  String get useBiometrics => 'استخدام البصمة';

  @override
  String get biometricsTitle => 'فتح بالبصمة';

  @override
  String get biometricsEnable => 'استخدم البصمة لفتح التطبيق';

  @override
  String get biometricsNotAvailable => 'البصمة غير متوفرة على هذا الجهاز';

  @override
  String get biometricFailed => 'فشل التحقق بالبصمة';

  @override
  String get themeSelectedLight => 'تم تطبيق الوضع الفاتح';

  @override
  String get themeSelectedDark => 'تم تطبيق الوضع الداكن';

  @override
  String get themeSelectedSystem => 'تم تطبيق وضع النظام';

  @override
  String languageChanged(Object lang) {
    return 'تم تغيير اللغة إلى $lang';
  }

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageHindi => 'الهندية';

  @override
  String get languageMalayalam => 'المالايالامية';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get exportCsv => 'تصدير بصيغة CSV';

  @override
  String get exportPdf => 'تصدير بصيغة PDF';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get restoreData => 'استعادة البيانات';

  @override
  String get developedBy => 'تم التطوير بواسطة نافاسكا';

  @override
  String get versionLabel => 'الإصدار';

  @override
  String lastUpdated(Object date) {
    return 'آخر تحديث $date';
  }

  @override
  String get feedback => 'ملاحظات';
}
