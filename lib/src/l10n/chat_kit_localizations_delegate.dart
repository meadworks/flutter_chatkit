import 'package:flutter/widgets.dart';
import 'chat_kit_localizations.dart';

/// Localizations delegate for ChatKit
class ChatKitLocalizationsDelegate extends LocalizationsDelegate<ChatKitLocalizations> {
  const ChatKitLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<ChatKitLocalizations> load(Locale locale) async {
    return const ChatKitLocalizationsEn();
  }

  @override
  bool shouldReload(ChatKitLocalizationsDelegate old) => false;
}
