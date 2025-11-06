import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ml.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('hi'),
    Locale('ml')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'FinTrack'**
  String get appTitle;

  /// No description provided for @addTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransactionTitle;

  /// No description provided for @editTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransactionTitle;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount (AED)'**
  String get amountLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category (e.g., Food, Taxi)'**
  String get categoryLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @pickDateButton.
  ///
  /// In en, this message translates to:
  /// **'Pick date'**
  String get pickDateButton;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButton;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @themeMenu.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get themeMenu;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactions;

  /// No description provided for @addFirstTransaction.
  ///
  /// In en, this message translates to:
  /// **'Tap the Add button to record your first expense or income.'**
  String get addFirstTransaction;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @setBudget.
  ///
  /// In en, this message translates to:
  /// **'Set budget'**
  String get setBudget;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get editBudget;

  /// No description provided for @budgetSet.
  ///
  /// In en, this message translates to:
  /// **'Budget set for this month'**
  String get budgetSet;

  /// No description provided for @noBudgetSet.
  ///
  /// In en, this message translates to:
  /// **'No budget set yet'**
  String get noBudgetSet;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand total'**
  String get grandTotal;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @amountError.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get amountError;

  /// No description provided for @positiveAmountError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid positive amount'**
  String get positiveAmountError;

  /// No description provided for @categoryError.
  ///
  /// In en, this message translates to:
  /// **'Enter a category'**
  String get categoryError;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// No description provided for @typeYourNote.
  ///
  /// In en, this message translates to:
  /// **'Type your note here...'**
  String get typeYourNote;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @yesterdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterdayLabel;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics & Insights'**
  String get insightsTitle;

  /// No description provided for @monthSelectorThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get monthSelectorThisMonth;

  /// No description provided for @prevMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get prevMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextMonth;

  /// No description provided for @net.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get net;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get byCategory;

  /// No description provided for @dailyExpenseTrend.
  ///
  /// In en, this message translates to:
  /// **'Daily expense trend'**
  String get dailyExpenseTrend;

  /// No description provided for @topCategories.
  ///
  /// In en, this message translates to:
  /// **'Top categories'**
  String get topCategories;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses for this month'**
  String get noExpenses;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @byNavas.
  ///
  /// In en, this message translates to:
  /// **'by MOHAMMED NAVAS'**
  String get byNavas;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @displayCurrency.
  ///
  /// In en, this message translates to:
  /// **'Display Currency'**
  String get displayCurrency;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate this App'**
  String get rateApp;

  /// No description provided for @currencyAed.
  ///
  /// In en, this message translates to:
  /// **'AED - United Arab Emirates Dirham'**
  String get currencyAed;

  /// No description provided for @currencyInr.
  ///
  /// In en, this message translates to:
  /// **'INR - Indian Rupee'**
  String get currencyInr;

  /// No description provided for @currencyUsd.
  ///
  /// In en, this message translates to:
  /// **'USD - US Dollar'**
  String get currencyUsd;

  /// No description provided for @currencyEur.
  ///
  /// In en, this message translates to:
  /// **'EUR - Euro'**
  String get currencyEur;

  /// No description provided for @currencySar.
  ///
  /// In en, this message translates to:
  /// **'SAR - Saudi Riyal'**
  String get currencySar;

  /// No description provided for @currencyQar.
  ///
  /// In en, this message translates to:
  /// **'QAR - Qatari Riyal'**
  String get currencyQar;

  /// No description provided for @currencyOmr.
  ///
  /// In en, this message translates to:
  /// **'OMR - Omani Rial'**
  String get currencyOmr;

  /// No description provided for @displayCurrencyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Converted to {currency} · Updated {time}'**
  String displayCurrencyUpdated(Object currency, Object time);

  /// No description provided for @currencyConversionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Conversion unavailable. Showing original currency.'**
  String get currencyConversionUnavailable;

  /// No description provided for @setPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get setPinTitle;

  /// No description provided for @setPinDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a 4–6 digit PIN to protect your app.'**
  String get setPinDescription;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @incorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get incorrectPin;

  /// No description provided for @pinNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PIN does not match'**
  String get pinNotMatch;

  /// No description provided for @pinTooShort.
  ///
  /// In en, this message translates to:
  /// **'PIN must be at least 4 digits'**
  String get pinTooShort;

  /// No description provided for @savePin.
  ///
  /// In en, this message translates to:
  /// **'Save PIN'**
  String get savePin;

  /// No description provided for @unlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockTitle;

  /// No description provided for @unlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockButton;

  /// No description provided for @useBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics'**
  String get useBiometrics;

  /// No description provided for @biometricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric Unlock'**
  String get biometricsTitle;

  /// No description provided for @biometricsEnable.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics to unlock'**
  String get biometricsEnable;

  /// No description provided for @biometricsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics not available on this device'**
  String get biometricsNotAvailable;

  /// No description provided for @biometricFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication failed'**
  String get biometricFailed;

  /// No description provided for @themeSelectedLight.
  ///
  /// In en, this message translates to:
  /// **'Light theme applied'**
  String get themeSelectedLight;

  /// No description provided for @themeSelectedDark.
  ///
  /// In en, this message translates to:
  /// **'Dark theme applied'**
  String get themeSelectedDark;

  /// No description provided for @themeSelectedSystem.
  ///
  /// In en, this message translates to:
  /// **'System theme applied'**
  String get themeSelectedSystem;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {lang}'**
  String languageChanged(Object lang);

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @languageMalayalam.
  ///
  /// In en, this message translates to:
  /// **'Malayalam'**
  String get languageMalayalam;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get exportCsv;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get exportPdf;

  /// No description provided for @backupData.
  ///
  /// In en, this message translates to:
  /// **'Backup Data'**
  String get backupData;

  /// No description provided for @restoreData.
  ///
  /// In en, this message translates to:
  /// **'Restore Data'**
  String get restoreData;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by Navaska'**
  String get developedBy;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {date}'**
  String lastUpdated(Object date);

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'hi', 'ml'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'ml': return AppLocalizationsMl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
