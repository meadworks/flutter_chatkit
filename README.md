# flutter_chat_kit_ui

An unofficial Flutter port of the [OpenAI ChatKit UI](https://platform.openai.com/docs/guides/chatkit). A drop-in chat widget that communicates with OpenAI ChatKit backends or any self-hosted server implementing the same HTTP/SSE protocol.

> **Note:** This package is not affiliated with or endorsed by OpenAI.

## Features

- Full chat interface out of the box -- message list, composer, history panel, start screen
- Real-time streaming via Server-Sent Events with hand-rolled parser
- Markdown rendering for assistant messages with annotation/citation support
- Thread management with cursor-based pagination
- File and image attachments with upload progress tracking
- Interactive widget system (cards, forms, tables, buttons, etc.)
- Workflow visualization (reasoning chains, search tasks, file tasks)
- Tool call display with status indicators
- Feedback, copy, and retry actions on messages
- Comprehensive theming (colors, typography, radius, density) with light/dark modes
- Localization support with English defaults
- Zero external state management dependencies -- built on `ChangeNotifier` + `InheritedWidget`

## Requirements

- Dart SDK `>=3.5.0`
- Flutter `>=3.22.0`

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_chat_kit_ui:
    path: ../flutter_chat_kit_ui  # local path
```

Or from a git repository:

```yaml
dependencies:
  flutter_chat_kit_ui:
    git:
      url: https://github.com/your-org/flutter_chat_kit_ui.git
      ref: main
```

## Quick start

### Self-hosted backend

```dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_kit_ui/flutter_chat_kit_ui.dart';

class MyChatScreen extends StatefulWidget {
  const MyChatScreen({super.key});

  @override
  State<MyChatScreen> createState() => _MyChatScreenState();
}

class _MyChatScreenState extends State<MyChatScreen> {
  late final ChatKitController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChatKitController(
      options: ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost:8000/chatkit'),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatKit(controller: _controller),
    );
  }
}
```

### OpenAI-hosted backend

```dart
_controller = ChatKitController(
  options: ChatKitOptions(
    api: HostedApiConfig(
      getClientSecret: (existing) async {
        // Call your backend to get a client secret token
        final response = await http.get(Uri.parse('/api/chatkit/token'));
        return jsonDecode(response.body)['client_secret'];
      },
    ),
  ),
);
```

## Configuration

`ChatKitOptions` controls every aspect of the UI. All sub-options have sensible defaults.

```dart
ChatKitOptions(
  api: CustomApiConfig(
    url: 'http://localhost:8000/chatkit',
    headers: {'X-Api-Key': 'your-key'},
  ),

  // Start screen with greeting and suggested prompts
  startScreen: StartScreenOption(
    greeting: 'How can I help you?',
    suggestedPrompts: [
      SuggestedPrompt(label: 'Tell me a joke', prompt: 'Tell me a funny joke'),
      SuggestedPrompt(label: 'Write a poem', prompt: 'Write a short poem'),
    ],
  ),

  // Header bar (set show: false to hide entirely)
  header: HeaderOption(
    show: true,
    title: 'My Assistant',
    showTitle: true,
    showHistoryButton: true,
    showModelPicker: false,
  ),

  // Thread history panel
  history: HistoryOption(enabled: true, pageSize: 20),

  // Composer
  composer: ComposerOption(
    placeholder: 'Ask me anything...',
    sendIcon: Icons.send,       // custom send button icon
    cancelIcon: Icons.close,    // custom cancel button icon
    fileUpload: FileUploadOption(
      enabled: true,
      maxFileSize: 10 * 1024 * 1024,
      allowedMimeTypes: ['image/png', 'image/jpeg', 'application/pdf'],
    ),
    showToolPicker: false,
    showModelPicker: false,
  ),

  // Message actions
  threadItemActions: ThreadItemActionsOption(
    showFeedback: true,
    showCopy: true,
    showRetry: true,
  ),

  // Disclaimer below composer
  disclaimer: DisclaimerOption(
    enabled: true,
    text: 'AI can make mistakes. Check important info.',
  ),

  // Event callbacks
  events: ChatKitEventCallbacks(
    onThreadCreated: (thread) => print('New thread: ${thread.id}'),
    onError: (code, message, allowRetry) => print('Error: $message'),
  ),
)
```

## Theming

`flutter_chat_kit_ui` has its own theme system that works alongside Flutter's `ThemeData`. If no `ChatKitTheme` is provided, it derives sensible defaults from the current Flutter theme.

```dart
// Use built-in light/dark themes
ChatKit(
  controller: _controller,
  theme: ChatKitThemeData.dark(),
)

// Customize specific aspects
ChatKit(
  controller: _controller,
  theme: ChatKitThemeData.light().copyWith(
    colorScheme: ChatKitColorScheme.light.copyWith(
      primary: Colors.indigo,
    ),
    typography: const ChatKitTypography(fontFamily: 'Inter'),
    radius: const ChatKitRadius(
      messageBubble: Radius.circular(20),
    ),
    density: const ChatKitDensity(
      messageSpacing: 12,
    ),
  ),
)

// Or wrap a subtree with ChatKitTheme directly
ChatKitTheme(
  data: ChatKitThemeData.dark(),
  child: ChatKit(controller: _controller),
)
```

## Controller API

`ChatKitController` is the primary programmatic interface. It composes several sub-controllers:

```dart
final controller = ChatKitController(options: options);

// Thread operations
await controller.selectThread('thread_123');
controller.startNewThread();
await controller.loadMoreThreads();

// Sending messages
controller.setComposerText('Hello!');
await controller.send();                     // creates thread or adds to active
controller.cancelStream();                   // cancel streaming response

// Retry and feedback
await controller.retryFromItem('item_456');
await controller.submitFeedback(['item_456'], 'thumbs_up');

// State accessors
controller.threads;          // List<ThreadMetadata>
controller.activeThread;     // Thread?
controller.items;            // List<ThreadItem> (current messages)
controller.isStreamActive;   // bool
controller.composerText;     // String
controller.canSend;          // bool

// Cleanup
controller.dispose();
```

## Architecture

```
flutter_chat_kit_ui/
  lib/src/
    models/          Data models (Thread, ThreadItem, Attachment, Annotation, ...)
    events/          SSE event types (ThreadStreamEvent, ThreadItemUpdate)
    client/          HTTP client, SSE parser, token manager
    config/          Configuration options
    state/           ChangeNotifier controllers
    theme/           Theming system (colors, typography, radius, density)
    widgets/         Flutter UI widgets
    widget_system/   Interactive widget renderer (cards, forms, tables)
    l10n/            Localization
```

Key design decisions:

- **Dart 3 sealed classes** for type-safe discriminated unions with exhaustive pattern matching
- **`ChangeNotifier` + `InheritedWidget`** for state management with zero external dependencies
- **Hand-rolled SSE parser** -- simple `data:` line protocol doesn't warrant a dependency
- **Composition over inheritance** -- small, focused, independently testable widgets

## Running tests

```bash
flutter test
```

209 tests covering model serialization, SSE parsing, configuration, token management, and theme behavior.

## License

See [LICENSE](LICENSE) for details.
