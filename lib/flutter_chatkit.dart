/// Flutter ChatKit - A drop-in chat UI widget compatible with OpenAI ChatKit backends.
library;

// Models - thread_item.dart exports all item types via part files
export 'src/models/thread.dart';
export 'src/models/thread_item.dart';
export 'src/models/attachment.dart';
export 'src/models/annotation.dart';
export 'src/models/entity.dart';
export 'src/models/inference_options.dart';
export 'src/models/page.dart';

// Events
export 'src/events/thread_stream_event.dart';
export 'src/events/thread_item_update.dart';
export 'src/events/chat_kit_event.dart';

// Client
export 'src/client/chat_kit_client.dart';
export 'src/client/custom_client.dart';
export 'src/client/hosted_client.dart';
export 'src/client/sse_parser.dart';
export 'src/client/sse_connection.dart';
export 'src/client/request_types.dart';
export 'src/client/token_manager.dart';

// State
export 'src/state/chat_kit_controller.dart';
export 'src/state/thread_controller.dart';
export 'src/state/message_controller.dart';
export 'src/state/attachment_controller.dart';
export 'src/state/widget_action_controller.dart';

// Config
export 'src/config/chat_kit_options.dart';
export 'src/config/api_config.dart';
export 'src/config/header_option.dart';
export 'src/config/history_option.dart';
export 'src/config/start_screen_option.dart';
export 'src/config/composer_option.dart';
export 'src/config/disclaimer_option.dart';
export 'src/config/entities_option.dart';
export 'src/config/thread_item_actions_option.dart';
export 'src/config/widgets_option.dart';
export 'src/config/tool_option.dart';
export 'src/config/model_option.dart';

// Theme
export 'src/theme/chat_kit_theme.dart';
export 'src/theme/chat_kit_theme_data.dart';
export 'src/theme/color_scheme_data.dart';
export 'src/theme/typography_data.dart';
export 'src/theme/radius_data.dart';
export 'src/theme/density_data.dart';

// L10n
export 'src/l10n/chat_kit_localizations.dart';
export 'src/l10n/chat_kit_localizations_delegate.dart';

// Widgets
export 'src/widgets/chat_kit.dart';
export 'src/widgets/chat_kit_inherited.dart';

// Widget System
export 'src/widget_system/widget_renderer.dart';
export 'src/widget_system/widget_models/widget_root.dart';
export 'src/widget_system/widget_models/widget_node.dart';
export 'src/widget_system/widget_models/widget_action.dart';
