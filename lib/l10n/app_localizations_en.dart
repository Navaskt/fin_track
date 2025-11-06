// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FinTrack';

  @override
  String get addTransactionTitle => 'Add Transaction';

  @override
  String get editTransactionTitle => 'Edit Transaction';

  @override
  String get amountLabel => 'Amount (AED)';

  @override
  String get categoryLabel => 'Category (e.g., Food, Taxi)';

  @override
  String get noteLabel => 'Note (optional)';

  @override
  String get dateLabel => 'Date';

  @override
  String get pickDateButton => 'Pick date';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get saveButton => 'Save';

  @override
  String get updateButton => 'Update';

  @override
  String get addButton => 'Add';

  @override
  String get themeMenu => 'Theme mode';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get addFirstTransaction => 'Tap the Add button to record your first expense or income.';

  @override
  String get budget => 'Budget';

  @override
  String get spent => 'Spent';

  @override
  String get remaining => 'Remaining';

  @override
  String get setBudget => 'Set budget';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get budgetSet => 'Budget set for this month';

  @override
  String get noBudgetSet => 'No budget set yet';

  @override
  String get grandTotal => 'Grand total';

  @override
  String get delete => 'Delete';

  @override
  String get amountError => 'Enter an amount';

  @override
  String get positiveAmountError => 'Enter a valid positive amount';

  @override
  String get categoryError => 'Enter a category';

  @override
  String get note => 'Note';

  @override
  String get editNote => 'Edit Note';

  @override
  String get typeYourNote => 'Type your note here...';

  @override
  String get clear => 'Clear';

  @override
  String get close => 'Close';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get todayLabel => 'Today';

  @override
  String get yesterdayLabel => 'Yesterday';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get insightsTitle => 'Analytics & Insights';

  @override
  String get monthSelectorThisMonth => 'This month';

  @override
  String get prevMonth => 'Previous';

  @override
  String get nextMonth => 'Next';

  @override
  String get net => 'Net';

  @override
  String get byCategory => 'By category';

  @override
  String get dailyExpenseTrend => 'Daily expense trend';

  @override
  String get topCategories => 'Top categories';

  @override
  String get noExpenses => 'No expenses for this month';

  @override
  String get noData => 'No data';

  @override
  String get byNavas => 'by MOHAMMED NAVAS';

  @override
  String get analytics => 'Analytics';

  @override
  String get settings => 'Settings';

  @override
  String get preferences => 'Preferences';

  @override
  String get security => 'Security';

  @override
  String get about => 'About';

  @override
  String get changePin => 'Change PIN';

  @override
  String get displayCurrency => 'Display Currency';

  @override
  String get appVersion => 'App Version';

  @override
  String get rateApp => 'Rate this App';

  @override
  String get currencyAed => 'AED - United Arab Emirates Dirham';

  @override
  String get currencyInr => 'INR - Indian Rupee';

  @override
  String get currencyUsd => 'USD - US Dollar';

  @override
  String get currencyEur => 'EUR - Euro';

  @override
  String get currencySar => 'SAR - Saudi Riyal';

  @override
  String get currencyQar => 'QAR - Qatari Riyal';

  @override
  String get currencyOmr => 'OMR - Omani Rial';

  @override
  String displayCurrencyUpdated(Object currency, Object time) {
    return 'Converted to $currency · Updated $time';
  }

  @override
  String get currencyConversionUnavailable => 'Conversion unavailable. Showing original currency.';

  @override
  String get setPinTitle => 'Set PIN';

  @override
  String get setPinSubtitle => 'Secure your app with a PIN';

  @override
  String get setPinDescription => 'Create a 4–6 digit PIN to protect your app.';

  @override
  String get confirmPin => 'Confirm PIN';

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get incorrectPin => 'Incorrect PIN';

  @override
  String get pinNotMatch => 'PIN does not match';

  @override
  String get pinTooShort => 'PIN must be at least 4 digits';

  @override
  String get pinHelper => '6 digits';

  @override
  String get savePin => 'Save PIN';

  @override
  String get unlockTitle => 'Unlock';

  @override
  String get unlockSubtitle => 'Enter your 6-digit PIN';

  @override
  String get unlockButton => 'Unlock';

  @override
  String get useBiometrics => 'Use biometrics';

  @override
  String get biometricsTitle => 'Biometric Unlock';

  @override
  String get biometricsEnable => 'Use biometrics to unlock';

  @override
  String get biometricsNotAvailable => 'Biometrics not available on this device';

  @override
  String get biometricFailed => 'Biometric authentication failed';

  @override
  String get themeSelectedLight => 'Light theme applied';

  @override
  String get themeSelectedDark => 'Dark theme applied';

  @override
  String get themeSelectedSystem => 'System theme applied';

  @override
  String languageChanged(Object lang) {
    return 'Language changed to $lang';
  }

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languageMalayalam => 'Malayalam';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportCsv => 'Export as CSV';

  @override
  String get exportPdf => 'Export as PDF';

  @override
  String get backupData => 'Backup Data';

  @override
  String get restoreData => 'Restore Data';

  @override
  String get developedBy => 'Developed by Navaska';

  @override
  String get versionLabel => 'Version';

  @override
  String lastUpdated(Object date) {
    return 'Last updated $date';
  }

  @override
  String get feedback => 'Feedback';
}
