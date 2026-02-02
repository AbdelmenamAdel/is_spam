enum SpamStatus { ham, spam, analyzing }

class SpamDetector {
  static final List<String> _spamKeywords = [
    'win',
    'free',
    'prize',
    'winner',
    'cash',
    'money',
    'urgent',
    'congratulations',
    'bank',
    'account',
    'verify',
    'click',
    'link',
    'offer',
    'loan',
    'credit',
    'discount',
    'gift',
    'claim',
    'award',
    'selected',
    'lottery',
    'inheritance',
    'viagra',
    'pharmacy',
    'crypto',
    'bitcoin',
    'investment',
    'bonus',
    'limited time',
    'act now',
    'urgent action',
    'suspended',
    'unauthorized',
    'security alert',
    'password',
    'login',
    'access',
    'update your info',
    'tax refund',
    'irs',
    'government',
    'official',
    'exclusive',
    'guaranteed',
    'risk-free',
    'no cost',
  ];

  static SpamStatus classify(String message) {
    if (message.isEmpty) return SpamStatus.ham;

    final lowerMessage = message.toLowerCase();
    int spamScore = 0;

    // Check for keywords
    for (final keyword in _spamKeywords) {
      if (lowerMessage.contains(keyword)) {
        spamScore++;
      }
    }

    // Check for suspicious patterns
    // 1. Links
    if (lowerMessage.contains('http://') || lowerMessage.contains('https://')) {
      spamScore += 2;
    }

    // 2. Shortened URLs
    final bitlyRegex = RegExp(r'bit\.ly|t\.co|goo\.gl|tinyurl\.com');
    if (bitlyRegex.hasMatch(lowerMessage)) {
      spamScore += 2;
    }

    // 3. All caps words (more than 4 letters)
    final allCapsRegex = RegExp(r'\b[A-Z]{5,}\b');
    if (allCapsRegex.hasMatch(message)) {
      spamScore += 1;
    }

    // 4. Numbers mixed with letters in weird ways
    final suspiciousString = RegExp(r'[a-zA-Z]+\d+[a-zA-Z]+|\d+[a-zA-Z]+\d+');
    if (suspiciousString.hasMatch(lowerMessage)) {
      spamScore += 1;
    }

    return spamScore >= 2 ? SpamStatus.spam : SpamStatus.ham;
  }

  // Simulates an API-based AI classification
  static Future<SpamStatus> analyzeWithAI(String message) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return classify(message);
  }
}
