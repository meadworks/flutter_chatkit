import 'package:flutter/material.dart';
import 'package:flutter_chat_kit_ui/flutter_chat_kit_ui.dart';

/// Example using the OpenAI-hosted ChatKit backend
class HostedExample extends StatefulWidget {
  const HostedExample({super.key});

  @override
  State<HostedExample> createState() => _HostedExampleState();
}

class _HostedExampleState extends State<HostedExample> {
  late final ChatKitController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChatKitController(
      options: ChatKitOptions(
        api: HostedApiConfig(
          getClientSecret: (existing) async {
            // In a real app, call your backend to get a client secret
            // e.g.: final response = await http.get(Uri.parse('/api/chatkit/token'));
            // return jsonDecode(response.body)['client_secret'];
            throw UnimplementedError(
              'Implement getClientSecret by calling your backend to get a token',
            );
          },
        ),
        startScreen: const StartScreenOption(
          greeting: 'How can I help you today?',
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
