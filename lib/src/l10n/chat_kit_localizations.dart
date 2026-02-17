import 'package:flutter/widgets.dart';

/// Abstract localization class for ChatKit strings
abstract class ChatKitLocalizations {
  const ChatKitLocalizations();

  /// The locale for these localizations
  Locale get locale;

  // Thread list
  String get historyTitle;
  String get noConversations;

  // Start screen
  String get defaultGreeting;

  // Composer
  String get composerPlaceholder;
  String get sendTooltip;
  String get stopGeneratingTooltip;

  // Header
  String get newChatTitle;
  String get newChatTooltip;
  String get openHistoryTooltip;
  String get closeHistoryTooltip;

  // Actions
  String get goodResponseTooltip;
  String get badResponseTooltip;
  String get copyTooltip;
  String get retryTooltip;

  // Misc
  String get generatingImage;
  String get errorPrefix;
  String get retryButton;
  String get runningToolCall;

  // Thread status
  String get untitled;
  String tasksCount(int count);

  static ChatKitLocalizations of(BuildContext context) {
    return Localizations.of<ChatKitLocalizations>(context, ChatKitLocalizations) ??
        const ChatKitLocalizationsEn();
  }
}

/// English localization (default)
class ChatKitLocalizationsEn extends ChatKitLocalizations {
  const ChatKitLocalizationsEn();

  @override
  Locale get locale => const Locale('en');

  @override String get historyTitle => 'History';
  @override String get noConversations => 'No conversations yet';
  @override String get defaultGreeting => 'How can I help you today?';
  @override String get composerPlaceholder => 'Type a message...';
  @override String get sendTooltip => 'Send message';
  @override String get stopGeneratingTooltip => 'Stop generating';
  @override String get newChatTitle => 'New chat';
  @override String get newChatTooltip => 'New chat';
  @override String get openHistoryTooltip => 'Open history';
  @override String get closeHistoryTooltip => 'Close history';
  @override String get goodResponseTooltip => 'Good response';
  @override String get badResponseTooltip => 'Bad response';
  @override String get copyTooltip => 'Copy';
  @override String get retryTooltip => 'Retry';
  @override String get generatingImage => 'Generating image...';
  @override String get errorPrefix => 'Error';
  @override String get retryButton => 'Retry';
  @override String get runningToolCall => 'Running...';
  @override String get untitled => 'Untitled';
  @override String tasksCount(int count) => '$count tasks';
}
