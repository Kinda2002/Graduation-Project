import 'package:flutter/cupertino.dart';

import 'appLocalizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations();
    // Handle the case where loading fails
    if (await localizations.load(locale)) {
      return localizations;
    } else {
      // Return a default instance of AppLocalizations in case of failure
      return AppLocalizations();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
