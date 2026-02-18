import 'package:flutter/material.dart';
import 'package:flutter_chatkit/flutter_chatkit.dart';

/// Example using a self-hosted ChatKit backend
class SelfHostedExample extends StatefulWidget {
  const SelfHostedExample({super.key});

  @override
  State<SelfHostedExample> createState() => _SelfHostedExampleState();
}

class _SelfHostedExampleState extends State<SelfHostedExample> {
  late final ChatKitController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChatKitController(
      options: const ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost:8000/chatkit'),
        startScreen: StartScreenOption(
          greeting: 'Welcome to Flutter ChatKit!',
          suggestedPrompts: [
            SuggestedPrompt(label: 'Tell me a joke', prompt: 'Tell me a funny joke'),
            SuggestedPrompt(label: 'Write a poem', prompt: 'Write a short poem about coding'),
            SuggestedPrompt(label: 'Explain quantum computing', prompt: 'Explain quantum computing in simple terms'),
          ],
        ),
        header: HeaderOption(showTitle: true),
        history: HistoryOption(enabled: true),
        composer: ComposerOption(placeholder: 'Ask me anything...'),
        disclaimer: DisclaimerOption(
          enabled: true,
          text: 'AI can make mistakes. Check important info.',
        ),
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
