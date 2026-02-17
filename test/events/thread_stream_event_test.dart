import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chatkit/flutter_chatkit.dart';

void main() {
  group('ThreadStreamEvent', () {
    test('ThreadCreatedEvent', () {
      final json = {
        'type': 'thread.created',
        'thread': {
          'id': 'thread_1',
          'title': 'Test',
          'created_at': '2024-01-01T00:00:00.000Z',
          'status': {'type': 'active'},
          'items': {'data': <dynamic>[], 'has_more': false},
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      expect(event, isA<ThreadCreatedEvent>());
      final created = event as ThreadCreatedEvent;
      expect(created.thread.id, 'thread_1');
      expect(created.thread.title, 'Test');
      expect(created.thread.status, isA<ActiveStatus>());
    });

    test('ThreadUpdatedEvent', () {
      final json = {
        'type': 'thread.updated',
        'thread': {
          'id': 'thread_1',
          'title': 'Updated Title',
          'created_at': '2024-01-01T00:00:00.000Z',
          'status': {'type': 'locked', 'reason': 'processing'},
          'items': {'data': <dynamic>[], 'has_more': false},
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      expect(event, isA<ThreadUpdatedEvent>());
      final updated = event as ThreadUpdatedEvent;
      expect(updated.thread.title, 'Updated Title');
      expect(updated.thread.status, isA<LockedStatus>());
    });

    test('ThreadItemAddedEvent', () {
      final json = {
        'type': 'thread.item.added',
        'item': {
          'type': 'assistant_message',
          'id': 'msg_1',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'output_text', 'text': ''},
          ],
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      expect(event, isA<ThreadItemAddedEvent>());
      final added = event as ThreadItemAddedEvent;
      expect(added.item, isA<AssistantMessageItem>());
      expect(added.item.id, 'msg_1');
    });

    test('ThreadItemUpdatedEvent with TextDelta', () {
      final json = {
        'type': 'thread.item.updated',
        'item_id': 'msg_1',
        'update': {
          'type': 'assistant_message.content_part.text.delta',
          'part_index': 0,
          'delta': 'Hello',
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      expect(event, isA<ThreadItemUpdatedEvent>());
      final updated = event as ThreadItemUpdatedEvent;
      expect(updated.itemId, 'msg_1');
      expect(updated.update, isA<TextDelta>());
      final delta = updated.update as TextDelta;
      expect(delta.delta, 'Hello');
      expect(delta.partIndex, 0);
    });

    test('ThreadItemUpdatedEvent with ContentPartAdded', () {
      final json = {
        'type': 'thread.item.updated',
        'item_id': 'msg_2',
        'update': {
          'type': 'assistant_message.content_part.added',
          'part_index': 0,
          'part': {'text': '', 'annotations': <dynamic>[]},
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      final updated = event as ThreadItemUpdatedEvent;
      expect(updated.update, isA<AssistantMessageContentPartAdded>());
      final partAdded = updated.update as AssistantMessageContentPartAdded;
      expect(partAdded.partIndex, 0);
      expect(partAdded.part.text, '');
    });

    test('ThreadItemUpdatedEvent with AnnotationAdded', () {
      final json = {
        'type': 'thread.item.updated',
        'item_id': 'msg_3',
        'update': {
          'type': 'assistant_message.content_part.annotation.added',
          'part_index': 0,
          'annotation': {
            'type': 'url_citation',
            'source': {
              'type': 'url',
              'url': 'https://example.com',
            },
            'index': 0,
          },
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      final updated = event as ThreadItemUpdatedEvent;
      expect(updated.update, isA<AnnotationAdded>());
      final annAdded = updated.update as AnnotationAdded;
      expect(annAdded.annotation.source, isA<UrlSource>());
    });

    test('ThreadItemUpdatedEvent with ContentPartDone', () {
      final json = {
        'type': 'thread.item.updated',
        'item_id': 'msg_4',
        'update': {
          'type': 'assistant_message.content_part.done',
          'part_index': 0,
          'part': {'text': 'Final text'},
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      final updated = event as ThreadItemUpdatedEvent;
      expect(updated.update, isA<ContentPartDone>());
      final done = updated.update as ContentPartDone;
      expect(done.part.text, 'Final text');
    });

    test('ThreadItemUpdatedEvent with WidgetDelta', () {
      final json = {
        'type': 'thread.item.updated',
        'item_id': 'w_1',
        'update': {
          'type': 'widget.delta',
          'delta': {'key': 'value'},
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      final updated = event as ThreadItemUpdatedEvent;
      expect(updated.update, isA<WidgetDelta>());
      final widgetDelta = updated.update as WidgetDelta;
      expect(widgetDelta.delta['key'], 'value');
    });

    test('ThreadItemUpdatedEvent with WorkflowTaskAdded', () {
      final json = {
        'type': 'thread.item.updated',
        'item_id': 'wf_1',
        'update': {
          'type': 'workflow.task.added',
          'task_index': 0,
          'task': {'type': 'thought', 'title': 'Thinking'},
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      final updated = event as ThreadItemUpdatedEvent;
      expect(updated.update, isA<WorkflowTaskAdded>());
      final taskAdded = updated.update as WorkflowTaskAdded;
      expect(taskAdded.taskIndex, 0);
      expect(taskAdded.task['type'], 'thought');
    });

    test('ThreadItemUpdatedEvent with WorkflowTaskUpdated', () {
      final json = {
        'type': 'thread.item.updated',
        'item_id': 'wf_1',
        'update': {
          'type': 'workflow.task.updated',
          'task_index': 1,
          'task': {'type': 'web_search', 'title': 'Searching...'},
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      final updated = event as ThreadItemUpdatedEvent;
      expect(updated.update, isA<WorkflowTaskUpdated>());
    });

    test('ThreadItemUpdatedEvent with WorkflowTaskDone', () {
      final json = {
        'type': 'thread.item.updated',
        'item_id': 'wf_1',
        'update': {
          'type': 'workflow.task.done',
          'task_index': 0,
          'task': {
            'type': 'thought',
            'title': 'Done thinking',
            'status_indicator': 'complete',
          },
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      final updated = event as ThreadItemUpdatedEvent;
      expect(updated.update, isA<WorkflowTaskDone>());
    });

    test('ThreadItemUpdatedEvent with WorkflowSummaryUpdated', () {
      final json = {
        'type': 'thread.item.updated',
        'item_id': 'wf_1',
        'update': {
          'type': 'workflow.summary.updated',
          'summary': {'duration': 3000},
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      final updated = event as ThreadItemUpdatedEvent;
      expect(updated.update, isA<WorkflowSummaryUpdated>());
      final summaryUpdated = updated.update as WorkflowSummaryUpdated;
      expect(summaryUpdated.summary['duration'], 3000);
    });

    test('ThreadItemUpdatedEvent with WorkflowExpandedUpdated', () {
      final json = {
        'type': 'thread.item.updated',
        'item_id': 'wf_1',
        'update': {
          'type': 'workflow.expanded.updated',
          'expanded': false,
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      final updated = event as ThreadItemUpdatedEvent;
      expect(updated.update, isA<WorkflowExpandedUpdated>());
      final expUpdate = updated.update as WorkflowExpandedUpdated;
      expect(expUpdate.expanded, false);
    });

    test('ThreadItemUpdatedEvent with GeneratedImageUpdated', () {
      final json = {
        'type': 'thread.item.updated',
        'item_id': 'img_1',
        'update': {
          'type': 'generated_image.updated',
          'image': {
            'id': 'gen_1',
            'url': 'https://example.com/image.png',
          },
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      final updated = event as ThreadItemUpdatedEvent;
      expect(updated.update, isA<GeneratedImageUpdated>());
      final imgUpdate = updated.update as GeneratedImageUpdated;
      expect(imgUpdate.image['url'], 'https://example.com/image.png');
    });

    test('ThreadItemDoneEvent', () {
      final json = {
        'type': 'thread.item.done',
        'item': {
          'type': 'assistant_message',
          'id': 'msg_5',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'output_text', 'text': 'Complete response'},
          ],
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      expect(event, isA<ThreadItemDoneEvent>());
      final done = event as ThreadItemDoneEvent;
      expect(done.item, isA<AssistantMessageItem>());
    });

    test('ThreadItemRemovedEvent', () {
      final json = {
        'type': 'thread.item.removed',
        'item_id': 'msg_to_remove',
      };

      final event = ThreadStreamEvent.fromJson(json);
      expect(event, isA<ThreadItemRemovedEvent>());
      final removed = event as ThreadItemRemovedEvent;
      expect(removed.itemId, 'msg_to_remove');
    });

    test('ThreadItemReplacedEvent', () {
      final json = {
        'type': 'thread.item.replaced',
        'item': {
          'type': 'user_message',
          'id': 'msg_replaced',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'input_text', 'text': 'Replaced content'},
          ],
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      expect(event, isA<ThreadItemReplacedEvent>());
      final replaced = event as ThreadItemReplacedEvent;
      expect(replaced.item.id, 'msg_replaced');
    });

    test('StreamOptionsEvent', () {
      final json = {
        'type': 'stream.options',
        'stream_options': {
          'supports_feedback': true,
          'supports_copy': true,
        },
      };

      final event = ThreadStreamEvent.fromJson(json);
      expect(event, isA<StreamOptionsEvent>());
      final opts = event as StreamOptionsEvent;
      expect(opts.streamOptions['supports_feedback'], true);
    });

    test('ProgressUpdateEvent', () {
      final json = {
        'type': 'progress.update',
        'icon': 'search',
        'text': 'Searching...',
      };

      final event = ThreadStreamEvent.fromJson(json);
      expect(event, isA<ProgressUpdateEvent>());
      final progress = event as ProgressUpdateEvent;
      expect(progress.icon, 'search');
      expect(progress.text, 'Searching...');
    });

    test('ProgressUpdateEvent with null fields', () {
      final json = {
        'type': 'progress.update',
      };

      final event = ThreadStreamEvent.fromJson(json);
      final progress = event as ProgressUpdateEvent;
      expect(progress.icon, isNull);
      expect(progress.text, isNull);
    });

    test('ClientEffectEvent', () {
      final json = {
        'type': 'client.effect',
        'name': 'scroll_to_bottom',
        'data': {'animate': true},
      };

      final event = ThreadStreamEvent.fromJson(json);
      expect(event, isA<ClientEffectEvent>());
      final effect = event as ClientEffectEvent;
      expect(effect.name, 'scroll_to_bottom');
      expect(effect.data!['animate'], true);
    });

    test('ClientEffectEvent with no data', () {
      final json = {
        'type': 'client.effect',
        'name': 'clear',
      };

      final event = ThreadStreamEvent.fromJson(json);
      final effect = event as ClientEffectEvent;
      expect(effect.data, isNull);
    });

    test('ErrorEvent', () {
      final json = {
        'type': 'error',
        'code': 'rate_limit',
        'message': 'Rate limited',
        'allow_retry': true,
      };

      final event = ThreadStreamEvent.fromJson(json);
      expect(event, isA<ErrorEvent>());
      final error = event as ErrorEvent;
      expect(error.code, 'rate_limit');
      expect(error.message, 'Rate limited');
      expect(error.allowRetry, true);
    });

    test('ErrorEvent with defaults', () {
      final json = {
        'type': 'error',
        'message': 'Something went wrong',
      };

      final event = ThreadStreamEvent.fromJson(json);
      final error = event as ErrorEvent;
      expect(error.code, isNull);
      expect(error.allowRetry, false);
    });

    test('NoticeEvent', () {
      final json = {
        'type': 'notice',
        'level': 'info',
        'message': 'Model updated',
        'title': 'Notice',
      };

      final event = ThreadStreamEvent.fromJson(json);
      expect(event, isA<NoticeEvent>());
      final notice = event as NoticeEvent;
      expect(notice.level, 'info');
      expect(notice.message, 'Model updated');
      expect(notice.title, 'Notice');
    });

    test('NoticeEvent without title', () {
      final json = {
        'type': 'notice',
        'level': 'warning',
        'message': 'Deprecation warning',
      };

      final event = ThreadStreamEvent.fromJson(json);
      final notice = event as NoticeEvent;
      expect(notice.title, isNull);
    });

    test('throws on unknown event type', () {
      final json = {
        'type': 'unknown.event',
        'data': {},
      };

      expect(
        () => ThreadStreamEvent.fromJson(json),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on unknown update type', () {
      final json = {
        'type': 'thread.item.updated',
        'item_id': 'msg_1',
        'update': {
          'type': 'unknown.update.type',
          'data': 'test',
        },
      };

      expect(
        () => ThreadStreamEvent.fromJson(json),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
