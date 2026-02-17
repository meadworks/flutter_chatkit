import 'api_config.dart';
import 'header_option.dart';
import 'history_option.dart';
import 'start_screen_option.dart';
import 'composer_option.dart';
import 'disclaimer_option.dart';
import 'entities_option.dart';
import 'thread_item_actions_option.dart';
import 'widgets_option.dart';
import 'tool_option.dart';
import 'model_option.dart';
import '../events/chat_kit_event.dart';

/// Top-level configuration for the ChatKit widget
class ChatKitOptions {
  const ChatKitOptions({
    required this.api,
    this.header = const HeaderOption(),
    this.history = const HistoryOption(),
    this.startScreen = const StartScreenOption(),
    this.composer = const ComposerOption(),
    this.disclaimer = const DisclaimerOption(),
    this.entities = const EntitiesOption(),
    this.threadItemActions = const ThreadItemActionsOption(),
    this.widgets = const WidgetsOption(),
    this.tools = const ToolOption(),
    this.models = const ModelOption(),
    this.events = const ChatKitEventCallbacks(),
  });

  final ApiConfig api;
  final HeaderOption header;
  final HistoryOption history;
  final StartScreenOption startScreen;
  final ComposerOption composer;
  final DisclaimerOption disclaimer;
  final EntitiesOption entities;
  final ThreadItemActionsOption threadItemActions;
  final WidgetsOption widgets;
  final ToolOption tools;
  final ModelOption models;
  final ChatKitEventCallbacks events;
}
