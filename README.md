# 💰 FinTrack - Personal Finance Manager

A powerful, feature-rich Flutter mobile app for tracking expenses, income, and budgets with beautiful visualizations, multi-language support, and offline-first architecture.

[![Flutter](https://img.shields.io/badge/Flutter-3.9+-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9+-blue?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightblue)](https://flutter.dev)

---

## 📱 Features

### 💳 **Transaction Management**
- ✅ **Add/Edit/Delete Transactions** - Easily record expenses and income
- ✅ **Categorized Transactions** - Pre-built categories for expenses (Food, Transport, Bills, etc.) and income (Salary, Bonus, etc.)
- ✅ **Transaction Notes** - Add detailed notes to transactions with quick copy-to-clipboard functionality
- ✅ **Date Selection** - Pick any date for historical transactions
- ✅ **Transaction Search & Filter** - Find transactions by category, date, or amount
- ✅ **Receipt Storage** - Attach receipt paths to transactions

### 📊 **Analytics & Insights**
- ✅ **Monthly Breakdown** - View transactions grouped by month
- ✅ **Daily Expense Chart** - Interactive line charts showing daily spending patterns
- ✅ **Budget vs Actual** - Visual comparison of spending against monthly budget with trend lines
- ✅ **Income & Expense Tracking** - Separate tracking for income and expenses
- ✅ **Monthly Summary** - Quick overview of total expenses, income, and net balance

### 💵 **Budget Management**
- ✅ **Set Monthly Budget** - Define spending limits per month
- ✅ **Budget Tracking** - See spent, remaining, and budget status
- ✅ **Budget Alerts** - Visual indicators when approaching or exceeding budget
- ✅ **Budget History** - Track budgets across multiple months

### 🌍 **Localization (Multi-Language)**
- ✅ **English (en)** - Full English interface
- ✅ **Arabic (ar)** - Complete Arabic translation with RTL support
- ✅ **Hindi (hi)** - Native Hindi translations
- ✅ **Malayalam (ml)** - Indian regional language support
- 🔄 Easy language switching in-app

### 🎨 **Themes & Customization**
- ✅ **Light Theme** - Clean, bright interface
- ✅ **Dark Theme** - Eye-friendly dark mode
- ✅ **System Theme** - Auto-adapt to device settings
- ✅ **Material Design 3** - Modern, accessible UI

### 🔒 **Security & Privacy**
- ✅ **Local-First Storage** - All data stored locally using Hive (no cloud dependency)
- ✅ **Biometric Authentication** - Support for fingerprint/face recognition (local_auth)
- ✅ **Secure Storage** - Sensitive data encrypted with flutter_secure_storage
- ✅ **No Internet Required** - Complete offline functionality

### 📤 **Export & Sharing**
- ✅ **PDF Export** - Export transactions as professional PDF reports
- ✅ **CSV Export** - Export data in CSV format for spreadsheet analysis
- ✅ **Date Range Selection** - Choose specific date ranges for exports
- ✅ **Share Reports** - Easily share exports via email, messaging, etc.
- ✅ **Custom Formatting** - Locale-aware number and currency formatting

### ⚡ **Performance & UX**
- ✅ **Smooth Animations** - Fluid transitions and interactions
- ✅ **Responsive Design** - Adapts to all screen sizes
- ✅ **Fast Search** - Quick access to transactions
- ✅ **Real-time Updates** - Stream-based data updates
- ✅ **Offline Support** - Full functionality without internet

---

## 🏗️ Architecture

FinTrack follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── app/                              # App-level configuration
│   ├── router.dart                  # Navigation & routing (GoRouter)
│   ├── theme/                       # Theme configuration (Light & Dark)
│   └── extension/                   # Context & utility extensions
│
├── core/                            # Core utilities & helpers
│   └── utils/
│
├── features/                        # Feature modules
│   ├── transactions/               # Main transaction feature
│   │   ├── domain/                # Business logic & entities
│   │   │   └── entities/
│   │   │       └── transaction_entity.dart
│   │   │
│   │   ├── data/                  # Data layer
│   │   │   ├── models/            # Transaction data models
│   │   │   ├── sources/           # Local data sources (Hive)
│   │   │   ├── repositories/      # Repository implementation
│   │   │   └── adapters/          # Hive adapters
│   │   │
│   │   └── presentation/          # UI & presentation layer
│   │       ├── pages/             # Full pages/screens
│   │       ├── widgets/           # Reusable widgets
│   │       ├── controllers/       # State management (Riverpod)
│   │       └── formatters/        # Number & date formatting
│   │
│   └── exports/                   # Export feature (PDF/CSV)
│       ├── data/                  # Export service
│       └── presentation/          # Export UI
│
├── l10n/                           # Localization
│   ├── arb/                       # ARB translation files
│   └── app_localizations_*.dart  # Generated translation classes
│
└── main.dart                       # App entry point
```

### Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **State Management** | Riverpod + Hooks | Reactive state & dependency injection |
| **Routing** | GoRouter | Modern, type-safe navigation |
| **Database** | Hive | Fast, local NoSQL database |
| **Charts** | FL Chart | Beautiful, interactive charts |
| **Security** | local_auth, flutter_secure_storage | Biometric & encrypted storage |
| **Export** | pdf, printing | PDF generation & sharing |
| **Code Generation** | Freezed | Immutable data classes |
| **Localization** | intl, ARB | Multi-language support |
| **Architecture** | Clean Architecture | Scalable, maintainable code |

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** 3.9.0+
- **Dart** 3.9.0+
- **Android Studio** or **Xcode** (for building)
- **Git**

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/Navaskt/fin_track.git
cd fin_track
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Generate code**
```bash
# Generate freezed classes, localizations, and other generated files
flutter pub run build_runner build --delete-conflicting-outputs
```

**4. Run the app**
```bash
# Debug mode
flutter run

# Release mode (iOS)
flutter run -t lib/main.dart --release

# Release mode (Android)
flutter run --release
```

### Supported Platforms

- ✅ **Android** 5.0+ (API 21+)
- ✅ **iOS** 12.0+

---

## 📚 Key Components

### Transaction Entity
```dart
TransactionEntity {
  String id,              // Unique identifier (UUID)
  double amount,          // Positive for income, negative for expense
  String category,        // E.g., "Food", "Salary"
  String? note,           // Optional note
  DateTime date,          // Transaction date
  String? receiptPath,    // Optional receipt file path
}
```

### State Management Pattern

Uses **Riverpod** for reactive, testable state management:

```dart
// Watch all transactions (reactive stream)
final transactionsStreamProvider = StreamProvider<List<TransactionEntity>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchAll();
});

// Budget for specific month
final budgetForMonthProvider = FutureProvider.family<double, DateTime>((ref, month) {
  return ref.watch(budgetRepositoryProvider).getBudgetForMonth(month);
});

// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
```

### Navigation Architecture

Uses **GoRouter** for modern, type-safe routing:

```dart
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/add', builder: (context, state) => const AddTransactionPage()),
      GoRoute(path: '/edit/:id', builder: (context, state) => EditTransactionPage(id: state.pathParameters['id']!)),
      GoRoute(path: '/analytics', builder: (context, state) => const AnalyticsPage()),
    ],
  );
});
```

---

## 🎯 Usage Guide

### Adding a Transaction

1. **Tap the "Add" button** (+ icon) on the home screen
2. **Select transaction type**: Expense or Income
3. **Enter amount** in AED
4. **Choose category** from predefined list or enter custom
5. **Pick date** (optional - defaults to today)
6. **Add note** (optional - for details like merchant name)
7. **Tap Save**

### Setting a Monthly Budget

1. **Navigate to** Monthly view
2. **Tap the Budget section** at the top
3. **Enter budget amount** for current month
4. **Tap Set Budget**
5. **Monitor spending** against budget in real-time

### Viewing Analytics

1. **Open Analytics tab** from bottom navigation
2. **Select date range** or view by month
3. **See interactive charts**:
   - Daily expense trend line
   - Budget comparison with cumulative expenses
   - Income vs Expense breakdown
4. **Tap on chart points** to drill down into specific dates

### Exporting Data

1. **Tap menu** → **Export**
2. **Select date range**
3. **Choose format**: PDF or CSV
4. **Share** via email, messaging, etc.

### Changing Language

1. **Tap menu** → **Settings**
2. **Select language**: English, العربية, हिन्दी, മലയാളം
3. **App UI updates** instantly

### Enabling Biometric Security

1. **Go to Settings**
2. **Tap Security**
3. **Enable Biometric Lock**
4. **App requires fingerprint/face on launch**

---

## 📊 Screenshot Features

### Home Screen
- Monthly transactions grouped by date
- Expandable month sections
- Quick transaction summary per month
- Daily expense chart with trend visualization

### Add/Edit Transaction
- Category quick-select chips
- Amount input with validation
- Date picker integration
- Note input with character counter
- Income/Expense toggle

### Analytics
- Line charts for daily spending patterns
- Budget vs actual comparison
- Monthly overview
- Export options for reports

### Settings
- Theme selection (Light/Dark/System)
- Language selection (4+ languages)
- Security settings
- App information

---

## 🔐 Security Features

### Data Privacy
- **Local-only storage**: No data sent to servers
- **Encrypted sensitive data**: Secure storage for app settings
- **No user tracking**: Complete privacy

### Authentication
- **Biometric lock**: Optional fingerprint/face ID
- **PIN protection**: Optional PIN backup
- **Session management**: Auto-lock after inactivity

### Data Protection
- **Hive encryption**: Database can be encrypted
- **Secure storage**: Sensitive keys stored securely
- **No backup exposure**: Data stays on device

---

## 🛠️ Development

### Project Structure

```bash
# Generate missing files/classes
flutter pub run build_runner build

# Watch for changes and rebuild
flutter pub run build_runner watch

# Clean and rebuild everything
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs

# Update localizations
flutter gen-l10n
```

### Adding New Localization

1. **Edit `lib/l10n/app_en.arb`** (English template)
2. **Create `lib/l10n/app_XX.arb`** for new language
3. **Run**: `flutter pub run build_runner build`
4. **Update supported locales** in `main.dart`

### Adding New Features

Follow the feature structure:

```
features/new_feature/
├── domain/
│   └── entities/
├── data/
│   ├── models/
│   ├── sources/
│   └── repositories/
└── presentation/
    ├── pages/
    ├── widgets/
    └── controllers/
```

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/transactions_test.dart
```

---

## 📦 Dependencies

### Core
- **flutter_riverpod** ^3.0.3 - State management
- **hooks_riverpod** ^3.0.3 - Hooks integration
- **flutter_hooks** ^0.21.3+1 - Functional widgets
- **go_router** ^17.2.3 - Routing

### Data & Models
- **hive** ^2.2.3 - Local database
- **hive_flutter** ^1.1.0 - Flutter integration
- **freezed_annotation** ^3.1.0 - Immutable models
- **json_annotation** ^4.9.0 - JSON serialization

### UI & Visualization
- **fl_chart** ^1.2.0 - Interactive charts
- **intl** ^0.20.2 - Internationalization

### Utilities
- **uuid** ^4.5.1 - Unique ID generation
- **path** ^1.9.1 - Path manipulation
- **path_provider** ^2.1.4 - Platform paths

### Security & Storage
- **local_auth** ^3.0.1 - Biometric authentication
- **flutter_secure_storage** ^10.2.0 - Encrypted storage
- **cryptography** ^2.7.0 - Encryption utilities

### Export & Sharing
- **pdf** ^3.11.0 - PDF generation
- **printing** ^5.13.4 - Print support
- **share_plus** ^13.1.0 - Share functionality

---

## 🐛 Troubleshooting

### Common Issues

**Issue**: Build fails with "Hive type adapter not found"
```bash
# Solution: Regenerate adapters
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

**Issue**: Localization strings not showing
```bash
# Solution: Generate localizations
flutter gen-l10n

# Or rebuild everything
flutter pub run build_runner build
```

**Issue**: Charts not displaying correctly
```dart
// Make sure date is valid and there are transactions
// Check that monthlyBudgetAED is properly initialized
```

**Issue**: Biometric lock not working
```bash
# Solution: Check platform-specific setup
# Android: Requires biometric permission in AndroidManifest.xml
# iOS: Requires NSFaceIDUsageDescription in Info.plist
```

---

## 🤝 Contributing

We welcome contributions! Follow these steps:

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** changes: `git commit -m 'Add amazing feature'`
4. **Push** to branch: `git push origin feature/amazing-feature`
5. **Open** a Pull Request

### Development Guidelines
- Follow Dart/Flutter best practices
- Write clean, commented code
- Add tests for new features
- Update documentation
- Use meaningful commit messages

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🎓 Learning Resources

This project demonstrates:
- ✅ **Clean Architecture** - Domain, Data, Presentation layers
- ✅ **State Management** - Riverpod patterns and best practices
- ✅ **Riverpod Patterns** - Providers, StateNotifiers, FutureProviders
- ✅ **GoRouter** - Modern navigation and deep linking
- ✅ **Hive Database** - NoSQL local storage
- ✅ **Freezed** - Immutable data classes
- ✅ **Localization** - Multi-language support with ARB
- ✅ **Flutter Hooks** - Functional widget patterns
- ✅ **Charts** - FL Chart integration for data visualization
- ✅ **Security** - Local auth and encrypted storage

Perfect for learning Flutter best practices!

---

## 🚀 Future Enhancements

- [ ] Cloud sync (Firebase)
- [ ] Recurring transactions
- [ ] Bill reminders
- [ ] Advanced analytics (pie charts, trends)
- [ ] Multiple accounts
- [ ] Budget categories
- [ ] Expense splitting
- [ ] Data backup & restore
- [ ] Widget integration
- [ ] Apple Watch support

---

## 📞 Support & Feedback

- 🐛 **Report Issues**: [GitHub Issues](https://github.com/Navaskt/fin_track/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/Navaskt/fin_track/discussions)
- 📧 **Email**: Contact via GitHub profile

---

## 👨‍💻 Author

**Navaskt**
- GitHub: [@Navaskt](https://github.com/Navaskt)
- Repository: [fin_track](https://github.com/Navaskt/fin_track)

---

## 🌟 Show Your Support

If you find FinTrack helpful, please:
- ⭐ **Star** this repository
- 🔄 **Share** with friends
- 💬 **Provide feedback**
- 🤝 **Contribute** improvements

---

## 📋 Changelog

### v1.0.0 (Current)
- ✅ Complete transaction management
- ✅ Budget tracking with visualizations
- ✅ Multi-language support (4 languages)
- ✅ Light & Dark themes
- ✅ Export to PDF & CSV
- ✅ Biometric security
- ✅ Local-only data storage
- ✅ Beautiful UI with Material Design 3

---

**Made with ❤️ in Flutter**

Last Updated: May 21, 2026 | Version: 1.0.0
