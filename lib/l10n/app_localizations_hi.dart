// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'स्पेंडली';

  @override
  String get addTransactionTitle => 'लेन-देन जोड़ें';

  @override
  String get editTransactionTitle => 'लेन-देन संपादित करें';

  @override
  String get amountLabel => 'राशि (AED)';

  @override
  String get categoryLabel => 'श्रेणी (जैसे: भोजन, टैक्सी)';

  @override
  String get noteLabel => 'नोट (वैकल्पिक)';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get pickDateButton => 'तारीख चुनें';

  @override
  String get expense => 'खर्च';

  @override
  String get income => 'आय';

  @override
  String get saveButton => 'सहेजें';

  @override
  String get updateButton => 'अपडेट करें';

  @override
  String get addButton => 'जोड़ें';

  @override
  String get themeMenu => 'थीम मोड';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get noTransactions => 'अभी तक कोई लेन-देन नहीं';

  @override
  String get addFirstTransaction => 'अपना पहला खर्च या आय जोड़ने के लिए Add बटन दबाएं。';

  @override
  String get budget => 'बजट';

  @override
  String get spent => 'खर्च किया';

  @override
  String get remaining => 'बाकी';

  @override
  String get setBudget => 'बजट सेट करें';

  @override
  String get editBudget => 'बजट संपादित करें';

  @override
  String get budgetSet => 'इस महीने के लिए बजट सेट किया गया है';

  @override
  String get noBudgetSet => 'अभी तक कोई बजट सेट नहीं किया गया';

  @override
  String get grandTotal => 'कुल राशि';

  @override
  String get delete => 'हटाएं';

  @override
  String get amountError => 'कृपया राशि दर्ज करें';

  @override
  String get positiveAmountError => 'सही धनात्मक राशि दर्ज करें';

  @override
  String get categoryError => 'कृपया श्रेणी दर्ज करें';

  @override
  String get note => 'नोट';

  @override
  String get editNote => 'नोट संपादित करें';

  @override
  String get typeYourNote => 'अपना नोट यहां लिखें...';

  @override
  String get clear => 'साफ करें';

  @override
  String get close => 'बंद करें';

  @override
  String get copiedToClipboard => 'क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get edit => 'संपादित करें';

  @override
  String get todayLabel => 'आज';

  @override
  String get yesterdayLabel => 'कल';

  @override
  String get changeLanguage => 'भाषा बदलें';

  @override
  String get insightsTitle => 'विश्लेषण और जानकारी';

  @override
  String get monthSelectorThisMonth => 'यह महीना';

  @override
  String get prevMonth => 'पिछला';

  @override
  String get nextMonth => 'अगला';

  @override
  String get net => 'शुद्ध';

  @override
  String get byCategory => 'श्रेणी अनुसार';

  @override
  String get dailyExpenseTrend => 'दैनिक खर्च प्रवृत्ति';

  @override
  String get topCategories => 'शीर्ष श्रेणियाँ';

  @override
  String get noExpenses => 'इस महीने के लिए कोई खर्च नहीं';

  @override
  String get noData => 'कोई डेटा नहीं';

  @override
  String get byNavas => 'खर्च ट्रैकर';

  @override
  String get analytics => 'विश्लेषण';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get preferences => 'प्राथमिकताएँ';

  @override
  String get security => 'सुरक्षा';

  @override
  String get about => 'जानकारी';

  @override
  String get changePin => 'पिन बदलें';

  @override
  String get displayCurrency => 'प्रदर्शित मुद्रा';

  @override
  String get appVersion => 'ऐप संस्करण';

  @override
  String get rateApp => 'ऐप रेट करें';

  @override
  String get currencyAed => 'एईडी - संयुक्त अरब अमीरात दिरहम';

  @override
  String get currencyInr => 'आईएनआर - भारतीय रुपया';

  @override
  String get currencyUsd => 'यूएसडी - अमेरिकी डॉलर';

  @override
  String get currencyEur => 'यूरो';

  @override
  String get currencySar => 'सऊदी रियाल';

  @override
  String get currencyQar => 'क़तरी रियाल';

  @override
  String get currencyOmr => 'ओमानी रियाल';

  @override
  String displayCurrencyUpdated(Object currency, Object time) {
    return '$currency में परिवर्तित · अद्यतन $time';
  }

  @override
  String get currencyConversionUnavailable => 'रूपांतरण उपलब्ध नहीं है। मूल मुद्रा दिखाई जा रही है।';

  @override
  String get setPinTitle => 'पिन सेट करें';

  @override
  String get setPinSubtitle => 'अपने ऐप को पिन से सुरक्षित करें';

  @override
  String get setPinDescription => 'ऐप को सुरक्षित रखने के लिए 4–6 अंकों का पिन बनाएं।';

  @override
  String get confirmPin => 'पिन की पुष्टि करें';

  @override
  String get enterPin => 'पिन दर्ज करें';

  @override
  String get incorrectPin => 'गलत पिन';

  @override
  String get pinNotMatch => 'पिन मेल नहीं खाता';

  @override
  String get pinTooShort => 'पिन कम से कम 4 अंकों का होना चाहिए';

  @override
  String get pinHelper => '6 अंक';

  @override
  String get savePin => 'पिन सहेजें';

  @override
  String get unlockTitle => 'अनलॉक करें';

  @override
  String get unlockSubtitle => 'अपना 6-अंकीय पिन दर्ज करें';

  @override
  String get unlockButton => 'अनलॉक';

  @override
  String get useBiometrics => 'बायोमेट्रिक का उपयोग करें';

  @override
  String get biometricsTitle => 'बायोमेट्रिक अनलॉक';

  @override
  String get biometricsEnable => 'ऐप खोलने के लिए बायोमेट्रिक का उपयोग करें';

  @override
  String get biometricsNotAvailable => 'इस डिवाइस पर बायोमेट्रिक उपलब्ध नहीं है';

  @override
  String get biometricFailed => 'बायोमेट्रिक प्रमाणीकरण विफल';

  @override
  String get themeSelectedLight => 'लाइट थीम लागू की गई';

  @override
  String get themeSelectedDark => 'डार्क थीम लागू की गई';

  @override
  String get themeSelectedSystem => 'सिस्टम थीम लागू की गई';

  @override
  String languageChanged(Object lang) {
    return 'भाषा $lang में बदली गई';
  }

  @override
  String get languageEnglish => 'अंग्रेज़ी';

  @override
  String get languageArabic => 'अरबी';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get languageMalayalam => 'मलयालम';

  @override
  String get exportData => 'डेटा निर्यात करें';

  @override
  String get exportCsv => 'CSV के रूप में निर्यात करें';

  @override
  String get exportPdf => 'PDF के रूप में निर्यात करें';

  @override
  String get backupData => 'डेटा बैकअप';

  @override
  String get restoreData => 'डेटा पुनर्स्थापित करें';

  @override
  String get developedBy => 'नवास्का द्वारा विकसित';

  @override
  String get versionLabel => 'संस्करण';

  @override
  String lastUpdated(Object date) {
    return 'अंतिम अद्यतन $date';
  }

  @override
  String get feedback => 'प्रतिक्रिया';

  @override
  String get food => 'खाद्य';

  @override
  String get groceries => 'किराना';

  @override
  String get transport => 'परिवहन';

  @override
  String get taxi => 'टैक्सी';

  @override
  String get bills => 'बिल';

  @override
  String get utilities => 'यूटिलिटीज';

  @override
  String get insurance => 'बीमा';

  @override
  String get creditCard => 'क्रेडिट कार्ड';

  @override
  String get credit => 'क्रेडिट';

  @override
  String get shopping => 'शॉपिंग';

  @override
  String get health => 'स्वास्थ्य';

  @override
  String get entertainment => 'मनोरंजन';

  @override
  String get rent => 'किराया';

  @override
  String get coffee => 'कॉफी';

  @override
  String get fuel => 'ईंधन';

  @override
  String get education => 'शिक्षा';

  @override
  String get other => 'अन्य';

  @override
  String get salary => 'वेतन';

  @override
  String get bonus => 'बोनस';

  @override
  String get interest => 'ब्याज';

  @override
  String get refund => 'रिफंड';

  @override
  String get gift => 'उपहार';

  @override
  String get investment => 'निवेश';

  @override
  String get incentive => 'प्रोत्साहन';
}
