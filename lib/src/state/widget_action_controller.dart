import 'package:flutter/foundation.dart';
import '../client/chat_kit_client.dart';
import '../client/request_types.dart';

/// Manages widget action dispatching
class WidgetActionController extends ChangeNotifier {
  WidgetActionController({required this.client});

  final ChatKitClient client;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  /// Dispatch a widget action
  Future<StreamResult> dispatchAction({
    required String threadId,
    required String itemId,
    required Map<String, dynamic> action,
  }) async {
    _isProcessing = true;
    notifyListeners();

    try {
      final result = await client.customAction(
        ThreadCustomActionRequest(
          threadId: threadId,
          itemId: itemId,
          action: action,
        ),
      );
      return result;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
