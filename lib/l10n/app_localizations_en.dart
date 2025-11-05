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
}
