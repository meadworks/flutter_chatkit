import 'dart:async';
import 'package:http/http.dart' as http;
import 'sse_parser.dart';

/// Represents an active SSE connection that can be cancelled
class SseConnection {
  SseConnection({
    required this.eventStream,
    required this.cancel,
  });

  /// Stream of parsed SSE event JSON objects
  final Stream<Map<String, dynamic>> eventStream;

  /// Cancel the connection
  final VoidCallback cancel;
}

/// Callback type for void functions
typedef VoidCallback = void Function();

/// Creates an SSE connection to a URL
class SseClient {
  SseClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  /// Open an SSE connection to the given URL with POST body
  Future<SseConnection> connect({
    required Uri uri,
    required Map<String, String> headers,
    required String body,
  }) async {
    final request = http.StreamedRequest('POST', uri);
    headers.forEach((key, value) {
      request.headers[key] = value;
    });
    request.headers['Accept'] = 'text/event-stream';
    request.headers['Content-Type'] = 'application/json';
    request.headers['Cache-Control'] = 'no-cache';

    // Write body and close
    request.sink.add(body.codeUnits);
    request.sink.close();

    final response = await _httpClient.send(request);

    if (response.statusCode != 200) {
      final responseBody = await response.stream.bytesToString();
      throw SseConnectionException(
        statusCode: response.statusCode,
        body: responseBody,
      );
    }

    bool cancelled = false;

    final controller = StreamController<Map<String, dynamic>>();

    final subscription = SseParser.parse(response.stream).listen(
      (event) {
        if (!cancelled && !controller.isClosed) {
          controller.add(event);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!cancelled && !controller.isClosed) {
          controller.addError(error, stackTrace);
        }
      },
      onDone: () {
        if (!controller.isClosed) {
          controller.close();
        }
      },
    );

    return SseConnection(
      eventStream: controller.stream,
      cancel: () {
        cancelled = true;
        subscription.cancel();
        if (!controller.isClosed) {
          controller.close();
        }
      },
    );
  }

  void dispose() {
    _httpClient.close();
  }
}

class SseConnectionException implements Exception {
  const SseConnectionException({required this.statusCode, required this.body});
  final int statusCode;
  final String body;

  @override
  String toString() => 'SseConnectionException($statusCode): $body';
}
