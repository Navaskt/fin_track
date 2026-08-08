import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReceiptOcrResult {
  const ReceiptOcrResult({this.amount, this.merchant, this.suggestedCategory});
  final double? amount;
  final String? merchant;
  final String? suggestedCategory;
}

class ReceiptOcrService {
  static final _recognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  static Future<ReceiptOcrResult> scan(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognized = await _recognizer.processImage(inputImage);

    final lines = recognized.blocks
        .expand((b) => b.lines)
        .map((l) => l.text.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final merchant = _extractMerchant(lines);
    final amount = _extractTotal(lines);

    return ReceiptOcrResult(
      amount: amount,
      merchant: merchant,
      suggestedCategory: _guessCategory(merchant, recognized.text),
    );
  }

  static final _totalKeywords = RegExp(
    r'(grand\s*total|total\s*due|amount\s*due|balance\s*due|total)',
    caseSensitive: false,
  );
  static final _numberPattern = RegExp(
    r'\d{1,3}(?:[.,]\d{3})*(?:[.,]\d{2})|\d+[.,]\d{2}',
  );

  static double? _extractTotal(List<String> lines) {
    // Pass 1: a line explicitly labeled "total" — most reliable
    for (final line in lines) {
      if (_totalKeywords.hasMatch(line)) {
        final matches = _numberPattern.allMatches(line).toList();
        if (matches.isNotEmpty) {
          final parsed = _parseNumber(matches.last.group(0)!);
          if (parsed != null) return parsed;
        }
      }
    }

    // Pass 2: fallback — largest currency-looking number on the receipt
    // (works reasonably well since the grand total is usually the biggest line item)
    final candidates = <double>[];
    for (final line in lines) {
      for (final match in _numberPattern.allMatches(line)) {
        final parsed = _parseNumber(match.group(0)!);
        if (parsed != null) candidates.add(parsed);
      }
    }
    if (candidates.isEmpty) return null;
    candidates.sort();
    return candidates.last;
  }

  static double? _parseNumber(String raw) {
    var cleaned = raw.replaceAll(RegExp(r'[^\d.,]'), '');
    if (cleaned.contains(',') && cleaned.contains('.')) {
      cleaned = cleaned.replaceAll(',', ''); // comma = thousands separator
    } else if (cleaned.contains(',')) {
      cleaned = cleaned.replaceAll(',', '.'); // comma = decimal separator
    }
    return double.tryParse(cleaned);
  }

  static String? _extractMerchant(List<String> lines) {
    // Store name is almost always in the first few lines, in letters (not a barcode/number row)
    for (final line in lines.take(5)) {
      final letters = line.replaceAll(RegExp(r'[^a-zA-Z]'), '');
      if (letters.length >= 3) return line;
    }
    return null;
  }

  static String? _guessCategory(String? merchant, String rawText) {
    final haystack = '${merchant ?? ''} $rawText'.toLowerCase();
    const map = {
      // --- Expense categories ---
      'Coffee': ['coffee', 'cafe', 'starbucks', 'costa', 'tim hortons'],
      'Groceries': [
        'market',
        'grocery',
        'groceries',
        'supermarket',
        'hypermarket',
        'carrefour',
        'lulu',
        'spinneys',
        'union coop',
        'waitrose',
      ],
      'Food': [
        'restaurant',
        'dinner',
        'lunch',
        'kitchen',
        'grill',
        'bakery',
        'diner',
        'eatery',
        'talabat',
        'zomato',
        'deliveroo',
        'mcdonald',
        'kfc',
        'burger',
      ],
      'Taxi': ['taxi', 'uber', 'careem', 'lyft', 'rta'],
      'Transport': [
        'metro',
        'bus',
        'parking',
        'salik',
        'toll',
        'transport',
        'train',
      ],
      'Fuel': ['petrol', 'fuel', 'gas station', 'enoc', 'adnoc', 'eppco'],
      'Bills': ['bill payment', 'invoice', 'postpaid', 'prepaid recharge'],
      'Utilities': [
        'dewa',
        'sewa',
        'addc',
        'electricity',
        'water bill',
        'internet',
        'du telecom',
        'etisalat',
        'wifi',
      ],
      'Insurance': ['insurance', 'premium', 'takaful'],
      'Credit Card': ['credit card payment', 'card payment', 'cc payment'],
      'Credit': ['loan', 'installment', 'emi', 'credit'],
      'Shopping': [
        'mall',
        'store',
        'shop',
        'amazon',
        'noon',
        'boutique',
        'outlet',
      ],
      'Health': [
        'pharmacy',
        'clinic',
        'medical',
        'hospital',
        'dental',
        'doctor',
      ],
      'Entertainment': [
        'cinema',
        'movie',
        'netflix',
        'spotify',
        'game',
        'entertainment',
        'theatre',
        'concert',
      ],
      'Rent': ['rent', 'landlord', 'lease', 'tenancy'],
      'Education': [
        'school',
        'university',
        'tuition',
        'course',
        'education',
        'academy',
      ],

      // --- Income categories ---
      'Salary': ['salary', 'payroll', 'wages'],
      'Bonus': ['bonus'],
      'Interest': ['interest earned', 'interest credit'],
      'Refund': ['refund', 'reversal', 'cashback'],
      'Gift': ['gift'],
      'Investment': ['dividend', 'investment', 'stock', 'mutual fund'],
      'Incentive': ['incentive', 'commission'],
    };
    for (final entry in map.entries) {
      if (entry.value.any(haystack.contains)) return entry.key;
    }
    return null;
  }

  static void dispose() => _recognizer.close();
}
