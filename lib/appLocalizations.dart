import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'appLocalizationsDelegate.dart';

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  static AppLocalizations? of(BuildContext context) {
    // Handle the case where context or the localization is null
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Map<String, String>? _localizedStrings;

  Future<bool> load(Locale locale) async {
    try {
      String jsonString = await rootBundle
          .loadString('assets/locales/${locale.languageCode}.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings =
          jsonMap.map((key, value) => MapEntry(key, value.toString()));
      return true;
    } catch (e) {
      print('Error loading localized strings: $e');
      return false;
    }
  }

  String translate(String key) {
    // Use null-aware operator to safely access _localizedStrings
    return _localizedStrings?[key] ?? '';
  }
}
