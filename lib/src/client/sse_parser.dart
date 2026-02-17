import 'dart:async';
import 'dart:convert';

/// Parses a byte stream into SSE events.
/// SSE format: lines prefixed with "data: ", separated by empty lines.
/// Stream terminates on [DONE] or data: [DONE].
class SseParser {
  /// Transforms a byte stream into a stream of parsed JSON objects.
  /// Each SSE event's data field is JSON-decoded.
  static Stream<Map<String, dynamic>> parse(Stream<List<int>> byteStream) {
    return _SseTransformer().bind(byteStream);
  }
}

class _SseTransformer extends StreamTransformerBase<List<int>, Map<String, dynamic>> {
  @override
  Stream<Map<String, dynamic>> bind(Stream<List<int>> stream) {
    return Stream.eventTransformed(stream, (sink) => _SseEventSink(sink));
  }
}

class _SseEventSink implements EventSink<List<int>> {
  _SseEventSink(this._outputSink);

  final EventSink<Map<String, dynamic>> _outputSink;
  final StringBuffer _lineBuffer = StringBuffer();
  final StringBuffer _dataBuffer = StringBuffer();

  @override
  void add(List<int> data) {
    final chunk = utf8.decode(data, allowMalformed: true);
    for (var i = 0; i < chunk.length; i++) {
      final char = chunk[i];
      if (char == '\n') {
        _processLine(_lineBuffer.toString());
        _lineBuffer.clear();
      } else if (char == '\r') {
        _processLine(_lineBuffer.toString());
        _lineBuffer.clear();
        // Skip \n if \r\n
        if (i + 1 < chunk.length && chunk[i + 1] == '\n') {
          i++;
        }
      } else {
        _lineBuffer.write(char);
      }
    }
  }

  void _processLine(String line) {
    if (line.isEmpty) {
      // Empty line = end of event
      _dispatchEvent();
    } else if (line.startsWith('data: ')) {
      final data = line.substring(6);
      if (data == '[DONE]') {
        _dispatchEvent();
        return;
      }
      if (_dataBuffer.isNotEmpty) {
        _dataBuffer.write('\n');
      }
      _dataBuffer.write(data);
    } else if (line.startsWith('event:') || line.startsWith('id:') || line.startsWith('retry:')) {
      // Ignore event, id, and retry fields for now
    } else if (line.startsWith(':')) {
      // Comment line, ignore
    }
  }

  void _dispatchEvent() {
    if (_dataBuffer.isEmpty) return;
    final data = _dataBuffer.toString();
    _dataBuffer.clear();
    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      _outputSink.add(json);
    } catch (e) {
      // Skip malformed JSON
    }
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _outputSink.addError(error, stackTrace);
  }

  @override
  void close() {
    // Flush any remaining data
    if (_lineBuffer.isNotEmpty) {
      _processLine(_lineBuffer.toString());
      _lineBuffer.clear();
    }
    _dispatchEvent();
    _outputSink.close();
  }
}
