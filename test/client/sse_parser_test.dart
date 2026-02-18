import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chatkit/flutter_chatkit.dart';

void main() {
  group('SseParser', () {
    test('parses a single SSE event', () async {
      const input = 'data: {"type": "test", "value": 1}\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
      expect(events[0]['type'], 'test');
      expect(events[0]['value'], 1);
    });

    test('parses multiple SSE events', () async {
      const input = 'data: {"type": "test", "value": 1}\n\n'
          'data: {"type": "test", "value": 2}\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 2);
      expect(events[0]['value'], 1);
      expect(events[1]['value'], 2);
    });

    test('handles [DONE] termination', () async {
      const input = 'data: {"type": "test"}\n\n'
          'data: [DONE]\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
    });

    test('handles multi-line data fields by joining with newlines', () async {
      const input = 'data: {"type":\n'
          'data: "test"}\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
      expect(events[0]['type'], 'test');
    });

    test('ignores comment lines starting with colon', () async {
      const input = ': this is a comment\n'
          'data: {"type": "test"}\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
    });

    test('ignores event: lines', () async {
      const input = 'event: message\n'
          'data: {"type": "test"}\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
      expect(events[0]['type'], 'test');
    });

    test('ignores id: lines', () async {
      const input = 'id: 123\n'
          'data: {"type": "test"}\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
    });

    test('ignores retry: lines', () async {
      const input = 'retry: 3000\n'
          'data: {"type": "test"}\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
    });

    test(r'handles \r\n line endings', () async {
      const input = 'data: {"type": "test"}\r\n\r\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
      expect(events[0]['type'], 'test');
    });

    test(r'handles \r line endings', () async {
      const input = 'data: {"type": "test"}\r\r';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
      expect(events[0]['type'], 'test');
    });

    test('handles chunked input split mid-data', () async {
      final chunk1 = utf8.encode('data: {"ty');
      final chunk2 = utf8.encode('pe": "test"}\n\n');

      final stream = Stream.fromIterable([chunk1, chunk2]);
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
      expect(events[0]['type'], 'test');
    });

    test('handles chunked input split across events', () async {
      final chunk1 =
          utf8.encode('data: {"type": "first"}\n\ndata: {"typ');
      final chunk2 = utf8.encode('e": "second"}\n\n');

      final stream = Stream.fromIterable([chunk1, chunk2]);
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 2);
      expect(events[0]['type'], 'first');
      expect(events[1]['type'], 'second');
    });

    test('handles many small chunks', () async {
      const fullInput = 'data: {"type": "test"}\n\n';
      final chunks = fullInput.split('').map((c) => utf8.encode(c));

      final stream = Stream.fromIterable(chunks);
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
      expect(events[0]['type'], 'test');
    });

    test('skips malformed JSON and continues', () async {
      const input = 'data: not json at all\n\n'
          'data: {"type": "valid"}\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
      expect(events[0]['type'], 'valid');
    });

    test('skips incomplete JSON and continues', () async {
      const input = 'data: {"type": "incomplete\n\n'
          'data: {"type": "complete"}\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
      expect(events[0]['type'], 'complete');
    });

    test('handles empty data between events', () async {
      const input = 'data: {"a": 1}\n\n'
          '\n'
          'data: {"b": 2}\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 2);
    });

    test('empty stream produces no events', () async {
      const stream = Stream<List<int>>.empty();
      final events = await SseParser.parse(stream).toList();

      expect(events, isEmpty);
    });

    test('stream with only comments produces no events', () async {
      const input = ': comment 1\n: comment 2\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events, isEmpty);
    });

    test('flushes pending data on stream close', () async {
      // Data without a trailing double newline - should be flushed on close
      const input = 'data: {"type": "flushed"}';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
      expect(events[0]['type'], 'flushed');
    });

    test('[DONE] after data does not produce extra events', () async {
      const input = 'data: {"seq": 1}\n\n'
          'data: {"seq": 2}\n\n'
          'data: [DONE]\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 2);
      expect(events[0]['seq'], 1);
      expect(events[1]['seq'], 2);
    });

    test('handles complex nested JSON', () async {
      final nested = {
        'type': 'complex',
        'data': {
          'items': [1, 2, 3],
          'nested': {'key': 'value'},
        },
      };
      final input = 'data: ${jsonEncode(nested)}\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
      expect(events[0]['data']['items'], [1, 2, 3]);
      expect(events[0]['data']['nested']['key'], 'value');
    });

    test('handles JSON with unicode characters', () async {
      const input = 'data: {"emoji": "\\u2764", "text": "hello"}\n\n';

      final stream = Stream.value(utf8.encode(input));
      final events = await SseParser.parse(stream).toList();

      expect(events.length, 1);
      expect(events[0]['text'], 'hello');
    });

    test('propagates stream errors', () async {
      final stream = Stream<List<int>>.error(Exception('connection lost'));

      expect(
        SseParser.parse(stream).toList(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
