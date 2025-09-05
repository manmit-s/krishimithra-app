import 'package:flutter/material.dart';

enum AppLanguage {
  english('English', 'en', '🇺🇸'),
  hindi('हिंदी', 'hi', '🇮🇳'),
  malayalam('മലയാളം', 'ml', '🇮🇳');

  const AppLanguage(this.displayName, this.code, this.flag);

  final String displayName;
  final String code;
  final String flag;
}

class LanguageProvider extends ChangeNotifier {
  AppLanguage _currentLanguage = AppLanguage.english; // Default to English

  AppLanguage get currentLanguage => _currentLanguage;

  /// Set the app language
  void setLanguage(AppLanguage language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      notifyListeners();
    }
  }

  /// Get greeting message based on current language
  String getGreeting() {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return 'Hello! I\'m KrishiMithra, your digital farming assistant. How can I help you today?';
      case AppLanguage.hindi:
        return 'नमस्ते! मैं कृषिमित्र हूं, आपका डिजिटल कृषि सहायक। आज मैं आपकी कैसे मदद कर सकता हूं?';
      case AppLanguage.malayalam:
        return 'ഹലോ! ഞാൻ കൃഷിമിത്രൻ ആണ്, നിങ്ങളുടെ ഡിജിറ്റൽ കൃഷി സഹായി. ഇന്ന് ഞാൻ നിങ്ങളെ എങ്ങനെ സഹായിക്കാം?';
    }
  }

  /// Get app bar title based on current language
  String getAppBarTitle() {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return 'KrishiMithra';
      case AppLanguage.hindi:
        return 'कृषिमित्र';
      case AppLanguage.malayalam:
        return 'കൃഷിമിത്രൻ';
    }
  }

  /// Get app bar subtitle based on current language
  String getAppBarSubtitle() {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return 'Digital Farming Assistant';
      case AppLanguage.hindi:
        return 'डिजिटल कृषि सहायक';
      case AppLanguage.malayalam:
        return 'ഡിജിറ്റൽ കൃഷി സഹായി';
    }
  }

  /// Get input hint text based on current language
  String getInputHint() {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return 'Type your message...';
      case AppLanguage.hindi:
        return 'अपना संदेश टाइप करें...';
      case AppLanguage.malayalam:
        return 'നിങ്ങളുടെ സന്ദേശം ടൈപ്പ് ചെയ്യുക...';
    }
  }

  /// Get loading text based on current language
  String getLoadingText() {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return 'KrishiMithra is typing...';
      case AppLanguage.hindi:
        return 'कृषिमित्र टाइप कर रहा है...';
      case AppLanguage.malayalam:
        return 'കൃഷിമിത്രൻ ടൈപ്പ് ചെയ്യുന്നു...';
    }
  }

  /// Get clear chat text based on current language
  String getClearChatText() {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return 'Clear Chat';
      case AppLanguage.hindi:
        return 'चैट साफ़ करें';
      case AppLanguage.malayalam:
        return 'ചാറ്റ് മായ്ക്കുക';
    }
  }

  /// Get theme settings text based on current language
  String getThemeSettingsText() {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return 'Theme Settings';
      case AppLanguage.hindi:
        return 'थीम सेटिंग्स';
      case AppLanguage.malayalam:
        return 'തീം ക്രമീകരണങ്ങൾ';
    }
  }

  /// Get language settings text based on current language
  String getLanguageSettingsText() {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return 'Language Settings';
      case AppLanguage.hindi:
        return 'भाषा सेटिंग्स';
      case AppLanguage.malayalam:
        return 'ഭാഷാ ക്രമീകരണങ്ങൾ';
    }
  }

  /// Get settings title based on current language
  String getSettingsTitle() {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return 'KrishiMithra Settings';
      case AppLanguage.hindi:
        return 'कृषिमित्र सेटिंग्स';
      case AppLanguage.malayalam:
        return 'കൃഷിമിത്രൻ ക്രമീകരണങ്ങൾ';
    }
  }
}
