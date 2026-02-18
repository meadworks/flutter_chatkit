import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chatkit/flutter_chatkit.dart';

void main() {
  group('ThreadItem', () {
    group('UserMessageItem', () {
      test('fromJson creates correct instance', () {
        final json = {
          'type': 'user_message',
          'id': 'msg_1',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'input_text', 'text': 'Hello world'},
          ],
        };

        final item = ThreadItem.fromJson(json);
        expect(item, isA<UserMessageItem>());
        final userMsg = item as UserMessageItem;
        expect(userMsg.id, 'msg_1');
        expect(userMsg.threadId, 'thread_1');
        expect(userMsg.type, 'user_message');
        expect(
          userMsg.createdAt,
          DateTime.utc(2024, 1, 1),
        );
        expect(userMsg.plainText, 'Hello world');
      });

      test('toJson produces valid output', () {
        final json = {
          'type': 'user_message',
          'id': 'msg_1',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'input_text', 'text': 'Hello world'},
          ],
        };

        final item = ThreadItem.fromJson(json) as UserMessageItem;
        final output = item.toJson();
        expect(output['type'], 'user_message');
        expect(output['id'], 'msg_1');
        expect(output['thread_id'], 'thread_1');
        expect(output['content'], isA<List>());
        expect((output['content'] as List).length, 1);
      });

      test('fromJson and toJson roundtrip preserves data', () {
        final json = {
          'type': 'user_message',
          'id': 'msg_1',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'input_text', 'text': 'Hello world'},
          ],
        };

        final item = ThreadItem.fromJson(json) as UserMessageItem;
        final output = item.toJson();
        final restored = ThreadItem.fromJson(output) as UserMessageItem;
        expect(restored.id, item.id);
        expect(restored.threadId, item.threadId);
        expect(restored.plainText, item.plainText);
      });

      test('handles tag content', () {
        final json = {
          'type': 'user_message',
          'id': 'msg_2',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'input_text', 'text': 'Hello '},
            {
              'type': 'input_tag',
              'id': 'entity_1',
              'text': '@John',
              'interactive': true,
            },
          ],
        };

        final item = ThreadItem.fromJson(json) as UserMessageItem;
        expect(item.plainText, 'Hello @John');
        expect(item.content.length, 2);
        expect(item.content[0], isA<UserMessageTextContent>());
        expect(item.content[1], isA<UserMessageTagContent>());

        final tag = item.content[1] as UserMessageTagContent;
        expect(tag.id, 'entity_1');
        expect(tag.text, '@John');
        expect(tag.interactive, true);
        expect(tag.data, isNull);
        expect(tag.group, isNull);
      });

      test('tag content with optional fields', () {
        final json = {
          'type': 'user_message',
          'id': 'msg_tag',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {
              'type': 'input_tag',
              'id': 'entity_2',
              'text': '@Team',
              'data': {'role': 'admin'},
              'group': 'teams',
              'interactive': false,
            },
          ],
        };

        final item = ThreadItem.fromJson(json) as UserMessageItem;
        final tag = item.content[0] as UserMessageTagContent;
        expect(tag.data, {'role': 'admin'});
        expect(tag.group, 'teams');
        expect(tag.interactive, false);
      });

      test('handles file attachments', () {
        final json = {
          'type': 'user_message',
          'id': 'msg_3',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'input_text', 'text': 'See attached'},
          ],
          'attachments': [
            {
              'type': 'file',
              'id': 'att_1',
              'name': 'doc.pdf',
              'mime_type': 'application/pdf',
            },
          ],
        };

        final item = ThreadItem.fromJson(json) as UserMessageItem;
        expect(item.attachments.length, 1);
        expect(item.attachments[0], isA<FileAttachment>());
        expect(item.attachments[0].name, 'doc.pdf');
        expect(item.attachments[0].mimeType, 'application/pdf');
        expect(item.attachments[0].id, 'att_1');
      });

      test('handles image attachments', () {
        final json = {
          'type': 'user_message',
          'id': 'msg_4',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'input_text', 'text': 'Check this image'},
          ],
          'attachments': [
            {
              'type': 'image',
              'id': 'att_2',
              'name': 'photo.jpg',
              'mime_type': 'image/jpeg',
              'preview_url': 'https://example.com/preview.jpg',
            },
          ],
        };

        final item = ThreadItem.fromJson(json) as UserMessageItem;
        expect(item.attachments.length, 1);
        final att = item.attachments[0] as ImageAttachment;
        expect(att.previewUrl, 'https://example.com/preview.jpg');
      });

      test('handles missing attachments gracefully', () {
        final json = {
          'type': 'user_message',
          'id': 'msg_5',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'input_text', 'text': 'No attachments'},
          ],
        };

        final item = ThreadItem.fromJson(json) as UserMessageItem;
        expect(item.attachments, isEmpty);
      });

      test('handles quoted text', () {
        final json = {
          'type': 'user_message',
          'id': 'msg_6',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'input_text', 'text': 'Reply to this'},
          ],
          'quoted_text': 'Original message text',
        };

        final item = ThreadItem.fromJson(json) as UserMessageItem;
        expect(item.quotedText, 'Original message text');
      });

      test('handles inference options', () {
        final json = {
          'type': 'user_message',
          'id': 'msg_7',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'input_text', 'text': 'Use specific model'},
          ],
          'inference_options': {
            'model': 'gpt-4',
            'tool_choice': {'id': 'tool_1'},
          },
        };

        final item = ThreadItem.fromJson(json) as UserMessageItem;
        expect(item.inferenceOptions, isNotNull);
        expect(item.inferenceOptions!.model, 'gpt-4');
        expect(item.inferenceOptions!.toolChoice!.id, 'tool_1');
      });

      test('plainText concatenates all content parts', () {
        final json = {
          'type': 'user_message',
          'id': 'msg_8',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'input_text', 'text': 'Hello '},
            {'type': 'input_text', 'text': 'World'},
            {
              'type': 'input_tag',
              'id': 'e1',
              'text': '!',
            },
          ],
        };

        final item = ThreadItem.fromJson(json) as UserMessageItem;
        expect(item.plainText, 'Hello World!');
      });

      test('toJson omits optional null fields', () {
        final json = {
          'type': 'user_message',
          'id': 'msg_9',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'input_text', 'text': 'Minimal'},
          ],
        };

        final item = ThreadItem.fromJson(json) as UserMessageItem;
        final output = item.toJson();
        expect(output.containsKey('attachments'), false);
        expect(output.containsKey('quoted_text'), false);
        expect(output.containsKey('inference_options'), false);
      });
    });

    group('AssistantMessageItem', () {
      test('fromJson creates correct instance', () {
        final json = {
          'type': 'assistant_message',
          'id': 'msg_10',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'output_text', 'text': 'Hello! How can I help?'},
          ],
        };

        final item = ThreadItem.fromJson(json) as AssistantMessageItem;
        expect(item.id, 'msg_10');
        expect(item.type, 'assistant_message');
        expect(item.fullText, 'Hello! How can I help?');
        expect(item.allAnnotations, isEmpty);
      });

      test('toJson roundtrip', () {
        final json = {
          'type': 'assistant_message',
          'id': 'msg_11',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'output_text', 'text': 'Response text'},
          ],
        };

        final item = ThreadItem.fromJson(json) as AssistantMessageItem;
        final output = item.toJson();
        final restored =
            ThreadItem.fromJson(output) as AssistantMessageItem;
        expect(restored.fullText, 'Response text');
      });

      test('fullText concatenates multiple content parts', () {
        final json = {
          'type': 'assistant_message',
          'id': 'msg_12',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'output_text', 'text': 'Part 1. '},
            {'type': 'output_text', 'text': 'Part 2.'},
          ],
        };

        final item = ThreadItem.fromJson(json) as AssistantMessageItem;
        expect(item.fullText, 'Part 1. Part 2.');
      });

      test('handles annotations', () {
        final json = {
          'type': 'assistant_message',
          'id': 'msg_13',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {
              'type': 'output_text',
              'text': 'According to sources...',
              'annotations': [
                {
                  'type': 'url_citation',
                  'source': {
                    'type': 'url',
                    'url': 'https://example.com',
                    'title': 'Example',
                  },
                  'index': 0,
                },
              ],
            },
          ],
        };

        final item = ThreadItem.fromJson(json) as AssistantMessageItem;
        expect(item.allAnnotations.length, 1);
        expect(item.allAnnotations[0].type, 'url_citation');
        expect(item.allAnnotations[0].index, 0);
        expect(item.allAnnotations[0].source, isA<UrlSource>());
        expect(
          (item.allAnnotations[0].source as UrlSource).url,
          'https://example.com',
        );
      });

      test('allAnnotations aggregates across content parts', () {
        final json = {
          'type': 'assistant_message',
          'id': 'msg_14',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {
              'type': 'output_text',
              'text': 'Part 1',
              'annotations': [
                {
                  'type': 'url_citation',
                  'source': {
                    'type': 'url',
                    'url': 'https://a.com',
                  },
                },
              ],
            },
            {
              'type': 'output_text',
              'text': 'Part 2',
              'annotations': [
                {
                  'type': 'file_citation',
                  'source': {
                    'type': 'file',
                    'filename': 'doc.pdf',
                  },
                },
              ],
            },
          ],
        };

        final item = ThreadItem.fromJson(json) as AssistantMessageItem;
        expect(item.allAnnotations.length, 2);
        expect(item.allAnnotations[0].source, isA<UrlSource>());
        expect(item.allAnnotations[1].source, isA<FileSource>());
      });

      test('content part with no annotations defaults to empty list', () {
        final json = {
          'type': 'assistant_message',
          'id': 'msg_15',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'output_text', 'text': 'No annotations here'},
          ],
        };

        final item = ThreadItem.fromJson(json) as AssistantMessageItem;
        expect(item.content[0].annotations, isEmpty);
      });

      test('AssistantMessageContent copyWith', () {
        const original = AssistantMessageContent(
          text: 'Original',
          annotations: [],
        );
        final modified = original.copyWith(text: 'Modified');
        expect(modified.text, 'Modified');
        expect(modified.annotations, isEmpty);
      });
    });

    group('ClientToolCallItem', () {
      test('fromJson creates correct instance', () {
        final json = {
          'type': 'tool_call',
          'id': 'tc_1',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'call_id': 'call_1',
          'name': 'get_weather',
          'arguments': '{"city": "SF"}',
          'status': 'completed',
          'output': '{"temp": 72}',
        };

        final item = ThreadItem.fromJson(json) as ClientToolCallItem;
        expect(item.name, 'get_weather');
        expect(item.callId, 'call_1');
        expect(item.arguments, '{"city": "SF"}');
        expect(item.status, ToolCallStatus.completed);
        expect(item.output, '{"temp": 72}');
      });

      test('toJson roundtrip', () {
        final json = {
          'type': 'tool_call',
          'id': 'tc_2',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'call_id': 'call_2',
          'name': 'search',
          'arguments': '{"q": "test"}',
          'status': 'pending',
        };

        final item = ThreadItem.fromJson(json) as ClientToolCallItem;
        final output = item.toJson();
        final restored = ThreadItem.fromJson(output) as ClientToolCallItem;
        expect(restored.name, 'search');
        expect(restored.status, ToolCallStatus.pending);
        expect(restored.output, isNull);
      });

      test('defaults to pending status when status missing', () {
        final json = {
          'type': 'tool_call',
          'id': 'tc_3',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'call_id': 'call_3',
          'name': 'my_tool',
          'arguments': '{}',
        };

        final item = ThreadItem.fromJson(json) as ClientToolCallItem;
        expect(item.status, ToolCallStatus.pending);
      });

      test('all ToolCallStatus values parse correctly', () {
        expect(ToolCallStatus.fromJson('pending'), ToolCallStatus.pending);
        expect(
          ToolCallStatus.fromJson('completed'),
          ToolCallStatus.completed,
        );
        expect(ToolCallStatus.fromJson('failed'), ToolCallStatus.failed);
      });

      test('ToolCallStatus.fromJson throws on unknown value', () {
        expect(
          () => ToolCallStatus.fromJson('unknown'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('ToolCallStatus.toJson returns name string', () {
        expect(ToolCallStatus.pending.toJson(), 'pending');
        expect(ToolCallStatus.completed.toJson(), 'completed');
        expect(ToolCallStatus.failed.toJson(), 'failed');
      });

      test('copyWith updates status and output', () {
        final item = ClientToolCallItem(
          id: 'tc_4',
          threadId: 'thread_1',
          createdAt: DateTime.utc(2024),
          callId: 'call_4',
          name: 'tool',
          arguments: '{}',
        );

        final updated = item.copyWith(
          status: ToolCallStatus.completed,
          output: 'result',
        );

        expect(updated.status, ToolCallStatus.completed);
        expect(updated.output, 'result');
        expect(updated.name, 'tool');
        expect(updated.id, 'tc_4');
      });

      test('toJson omits output when null', () {
        final item = ClientToolCallItem(
          id: 'tc_5',
          threadId: 'thread_1',
          createdAt: DateTime.utc(2024),
          callId: 'call_5',
          name: 'tool',
          arguments: '{}',
        );

        final output = item.toJson();
        expect(output.containsKey('output'), false);
      });
    });

    group('WidgetItem', () {
      test('fromJson creates correct instance', () {
        final json = {
          'type': 'widget',
          'id': 'w_1',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'widget': {'component': 'chart', 'data': [1, 2, 3]},
          'copy_text': 'Chart data: 1, 2, 3',
        };

        final item = ThreadItem.fromJson(json) as WidgetItem;
        expect(item.widget['component'], 'chart');
        expect(item.copyText, 'Chart data: 1, 2, 3');
        expect(item.type, 'widget');
      });

      test('toJson roundtrip', () {
        final json = {
          'type': 'widget',
          'id': 'w_2',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'widget': {'key': 'value'},
        };

        final item = ThreadItem.fromJson(json) as WidgetItem;
        final output = item.toJson();
        final restored = ThreadItem.fromJson(output) as WidgetItem;
        expect(restored.widget['key'], 'value');
        expect(restored.copyText, isNull);
      });

      test('toJson omits copy_text when null', () {
        final item = WidgetItem(
          id: 'w_3',
          threadId: 'thread_1',
          createdAt: DateTime.utc(2024),
          widget: {'x': 1},
        );

        final output = item.toJson();
        expect(output.containsKey('copy_text'), false);
      });
    });

    group('WorkflowItem', () {
      test('fromJson with thought and search tasks', () {
        final json = {
          'type': 'workflow',
          'id': 'wf_1',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'workflow': {
            'type': 'reasoning',
            'tasks': [
              {
                'type': 'thought',
                'title': 'Thinking...',
                'content': 'Let me consider...',
                'status_indicator': 'complete',
              },
              {
                'type': 'web_search',
                'title': 'Searching',
                'queries': ['flutter chatkit'],
                'status_indicator': 'loading',
              },
            ],
            'expanded': true,
          },
        };

        final item = ThreadItem.fromJson(json) as WorkflowItem;
        expect(item.type, 'workflow');
        expect(item.workflow.workflowType, 'reasoning');
        expect(item.workflow.tasks.length, 2);
        expect(item.workflow.tasks[0], isA<ThoughtTask>());
        expect(item.workflow.tasks[1], isA<SearchTask>());
        expect(item.workflow.expanded, true);

        final thought = item.workflow.tasks[0] as ThoughtTask;
        expect(thought.title, 'Thinking...');
        expect(thought.content, 'Let me consider...');
        expect(thought.statusIndicator, 'complete');

        final search = item.workflow.tasks[1] as SearchTask;
        expect(search.title, 'Searching');
        expect(search.queries, ['flutter chatkit']);
        expect(search.statusIndicator, 'loading');
      });

      test('fromJson with custom task', () {
        final json = {
          'type': 'workflow',
          'id': 'wf_2',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'workflow': {
            'type': 'custom',
            'tasks': [
              {
                'type': 'custom',
                'title': 'Custom step',
                'icon': 'star',
                'content': 'Some content',
                'status_indicator': 'none',
              },
            ],
          },
        };

        final item = ThreadItem.fromJson(json) as WorkflowItem;
        final task = item.workflow.tasks[0] as CustomTask;
        expect(task.title, 'Custom step');
        expect(task.icon, 'star');
        expect(task.content, 'Some content');
      });

      test('fromJson with file task', () {
        final json = {
          'type': 'workflow',
          'id': 'wf_3',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'workflow': {
            'tasks': [
              {
                'type': 'file',
                'title': 'Reading files',
                'sources': [
                  {
                    'type': 'file',
                    'filename': 'data.csv',
                    'title': 'Data File',
                  },
                ],
              },
            ],
          },
        };

        final item = ThreadItem.fromJson(json) as WorkflowItem;
        final task = item.workflow.tasks[0] as FileTask;
        expect(task.title, 'Reading files');
        expect(task.sources.length, 1);
        expect(task.sources[0], isA<FileSource>());
      });

      test('fromJson with image task', () {
        final json = {
          'type': 'workflow',
          'id': 'wf_4',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'workflow': {
            'tasks': [
              {
                'type': 'image',
                'title': 'Generating image',
                'status_indicator': 'loading',
              },
            ],
          },
        };

        final item = ThreadItem.fromJson(json) as WorkflowItem;
        final task = item.workflow.tasks[0] as ImageTask;
        expect(task.title, 'Generating image');
        expect(task.statusIndicator, 'loading');
      });

      test('workflow with duration summary', () {
        final json = {
          'type': 'workflow',
          'id': 'wf_5',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'workflow': {
            'tasks': [],
            'summary': {'duration': 5000},
          },
        };

        final item = ThreadItem.fromJson(json) as WorkflowItem;
        expect(item.workflow.summary, isA<DurationSummary>());
        expect((item.workflow.summary as DurationSummary).duration, 5000);
      });

      test('workflow with custom summary', () {
        final json = {
          'type': 'workflow',
          'id': 'wf_6',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'workflow': {
            'tasks': [],
            'summary': {'title': 'Completed', 'icon': 'check'},
          },
        };

        final item = ThreadItem.fromJson(json) as WorkflowItem;
        expect(item.workflow.summary, isA<CustomSummary>());
        final summary = item.workflow.summary as CustomSummary;
        expect(summary.title, 'Completed');
        expect(summary.icon, 'check');
      });

      test('workflow defaults', () {
        final json = {
          'type': 'workflow',
          'id': 'wf_7',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'workflow': <String, dynamic>{},
        };

        final item = ThreadItem.fromJson(json) as WorkflowItem;
        expect(item.workflow.workflowType, 'custom');
        expect(item.workflow.tasks, isEmpty);
        expect(item.workflow.summary, isNull);
        expect(item.workflow.expanded, false);
      });

      test('toJson roundtrip', () {
        final json = {
          'type': 'workflow',
          'id': 'wf_8',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'workflow': {
            'type': 'reasoning',
            'tasks': [
              {
                'type': 'thought',
                'title': 'Thinking',
                'status_indicator': 'complete',
              },
            ],
            'expanded': true,
          },
        };

        final item = ThreadItem.fromJson(json) as WorkflowItem;
        final output = item.toJson();
        final restored = ThreadItem.fromJson(output) as WorkflowItem;
        expect(restored.workflow.workflowType, 'reasoning');
        expect(restored.workflow.tasks.length, 1);
        expect(restored.workflow.expanded, true);
      });

      test('Task.fromJson throws on unknown type', () {
        expect(
          () => Task.fromJson({'type': 'unknown', 'title': 'x'}),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('GeneratedImageItem', () {
      test('fromJson creates correct instance', () {
        final json = {
          'type': 'generated_image',
          'id': 'img_1',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'image': {
            'id': 'gen_1',
            'url': 'https://example.com/image.png',
          },
        };

        final item = ThreadItem.fromJson(json) as GeneratedImageItem;
        expect(item.type, 'generated_image');
        expect(item.image.id, 'gen_1');
        expect(item.image.url, 'https://example.com/image.png');
      });

      test('handles image with null url', () {
        final json = {
          'type': 'generated_image',
          'id': 'img_2',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'image': {
            'id': 'gen_2',
          },
        };

        final item = ThreadItem.fromJson(json) as GeneratedImageItem;
        expect(item.image.url, isNull);
      });

      test('toJson roundtrip', () {
        final json = {
          'type': 'generated_image',
          'id': 'img_3',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'image': {
            'id': 'gen_3',
            'url': 'https://example.com/img.png',
          },
        };

        final item = ThreadItem.fromJson(json) as GeneratedImageItem;
        final output = item.toJson();
        final restored = ThreadItem.fromJson(output) as GeneratedImageItem;
        expect(restored.image.url, 'https://example.com/img.png');
      });

      test('GeneratedImage toJson omits url when null', () {
        const image = GeneratedImage(id: 'gen_4');
        final json = image.toJson();
        expect(json.containsKey('url'), false);
        expect(json['id'], 'gen_4');
      });
    });

    group('EndOfTurnItem', () {
      test('fromJson creates correct instance', () {
        final json = {
          'type': 'end_of_turn',
          'id': 'eot_1',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
        };

        final item = ThreadItem.fromJson(json);
        expect(item, isA<EndOfTurnItem>());
        expect(item.id, 'eot_1');
        expect(item.type, 'end_of_turn');
      });

      test('toJson roundtrip', () {
        final json = {
          'type': 'end_of_turn',
          'id': 'eot_2',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
        };

        final item = ThreadItem.fromJson(json) as EndOfTurnItem;
        final output = item.toJson();
        final restored = ThreadItem.fromJson(output) as EndOfTurnItem;
        expect(restored.id, 'eot_2');
        expect(restored.threadId, 'thread_1');
      });
    });

    group('ThreadItem.fromJson error handling', () {
      test('throws ArgumentError for unknown type', () {
        final json = {
          'type': 'unknown_type',
          'id': 'x',
          'thread_id': 'x',
          'created_at': '2024-01-01T00:00:00.000Z',
        };

        expect(
          () => ThreadItem.fromJson(json),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws on unknown content type in UserMessage', () {
        final json = {
          'type': 'user_message',
          'id': 'msg_err',
          'thread_id': 'thread_1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'content': [
            {'type': 'unknown_content', 'text': 'oops'},
          ],
        };

        expect(
          () => ThreadItem.fromJson(json),
          throwsA(isA<ArgumentError>()),
        );
      });
    });
  });

  group('Thread', () {
    test('fromJson creates correct instance', () {
      final json = {
        'id': 'thread_1',
        'title': 'My Thread',
        'created_at': '2024-01-01T00:00:00.000Z',
        'status': {'type': 'active'},
        'items': {
          'data': <dynamic>[],
          'has_more': false,
        },
      };

      final thread = Thread.fromJson(json);
      expect(thread.id, 'thread_1');
      expect(thread.title, 'My Thread');
      expect(thread.status, isA<ActiveStatus>());
      expect(thread.items.data, isEmpty);
      expect(thread.items.hasMore, false);
    });

    test('fromJson with items', () {
      final json = {
        'id': 'thread_2',
        'title': 'Thread With Items',
        'created_at': '2024-01-01T00:00:00.000Z',
        'status': {'type': 'active'},
        'items': {
          'data': [
            {
              'type': 'user_message',
              'id': 'msg_1',
              'thread_id': 'thread_2',
              'created_at': '2024-01-01T00:00:00.000Z',
              'content': [
                {'type': 'input_text', 'text': 'Hi'},
              ],
            },
          ],
          'has_more': true,
          'after': 'cursor_abc',
        },
      };

      final thread = Thread.fromJson(json);
      expect(thread.items.data.length, 1);
      expect(thread.items.data[0], isA<UserMessageItem>());
      expect(thread.items.hasMore, true);
      expect(thread.items.after, 'cursor_abc');
    });

    test('fromJson with null title', () {
      final json = {
        'id': 'thread_3',
        'title': null,
        'created_at': '2024-01-01T00:00:00.000Z',
        'status': {'type': 'active'},
        'items': {
          'data': <dynamic>[],
          'has_more': false,
        },
      };

      final thread = Thread.fromJson(json);
      expect(thread.title, isNull);
    });

    test('fromJson with metadata', () {
      final json = {
        'id': 'thread_4',
        'title': 'With Metadata',
        'created_at': '2024-01-01T00:00:00.000Z',
        'status': {'type': 'active'},
        'metadata': {'key': 'value'},
        'items': {
          'data': <dynamic>[],
          'has_more': false,
        },
      };

      final thread = Thread.fromJson(json);
      expect(thread.metadata['key'], 'value');
    });

    test('toJson roundtrip', () {
      final json = {
        'id': 'thread_5',
        'title': 'Roundtrip',
        'created_at': '2024-01-01T00:00:00.000Z',
        'status': {'type': 'locked', 'reason': 'processing'},
        'items': {
          'data': <dynamic>[],
          'has_more': false,
        },
      };

      final thread = Thread.fromJson(json);
      final output = thread.toJson();
      expect(output['id'], 'thread_5');
      expect(output['title'], 'Roundtrip');
      expect(output['status']['type'], 'locked');
      expect(output['status']['reason'], 'processing');
    });
  });

  group('ThreadStatus', () {
    test('ActiveStatus fromJson and toJson', () {
      final status = ThreadStatus.fromJson({'type': 'active'});
      expect(status, isA<ActiveStatus>());
      expect(status.toJson()['type'], 'active');
    });

    test('LockedStatus fromJson with reason', () {
      final status = ThreadStatus.fromJson(
        {'type': 'locked', 'reason': 'processing'},
      );
      expect(status, isA<LockedStatus>());
      final locked = status as LockedStatus;
      expect(locked.reason, 'processing');
    });

    test('LockedStatus fromJson without reason', () {
      final status = ThreadStatus.fromJson({'type': 'locked'});
      expect((status as LockedStatus).reason, isNull);
    });

    test('ClosedStatus fromJson with reason', () {
      final status = ThreadStatus.fromJson(
        {'type': 'closed', 'reason': 'done'},
      );
      expect(status, isA<ClosedStatus>());
      expect((status as ClosedStatus).reason, 'done');
    });

    test('ClosedStatus fromJson without reason', () {
      final status = ThreadStatus.fromJson({'type': 'closed'});
      expect((status as ClosedStatus).reason, isNull);
    });

    test('throws on unknown status type', () {
      expect(
        () => ThreadStatus.fromJson({'type': 'deleted'}),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('LockedStatus toJson omits reason when null', () {
      const status = LockedStatus();
      final json = status.toJson();
      expect(json['type'], 'locked');
      expect(json.containsKey('reason'), false);
    });

    test('ClosedStatus toJson omits reason when null', () {
      const status = ClosedStatus();
      final json = status.toJson();
      expect(json['type'], 'closed');
      expect(json.containsKey('reason'), false);
    });
  });

  group('ThreadMetadata', () {
    test('fromJson', () {
      final json = {
        'id': 'tm_1',
        'title': 'Thread Title',
        'created_at': '2024-01-01T00:00:00.000Z',
        'status': {'type': 'active'},
      };

      final meta = ThreadMetadata.fromJson(json);
      expect(meta.id, 'tm_1');
      expect(meta.title, 'Thread Title');
      expect(meta.status, isA<ActiveStatus>());
      expect(meta.metadata, isEmpty);
    });

    test('copyWith', () {
      final meta = ThreadMetadata(
        id: 'tm_2',
        title: 'Original',
        createdAt: DateTime.utc(2024),
        status: const ActiveStatus(),
      );

      final updated = meta.copyWith(title: 'Updated');
      expect(updated.title, 'Updated');
      expect(updated.id, 'tm_2');
    });

    test('toJson', () {
      final meta = ThreadMetadata(
        id: 'tm_3',
        title: 'Test',
        createdAt: DateTime.utc(2024),
        status: const ActiveStatus(),
        metadata: {'custom': true},
      );

      final json = meta.toJson();
      expect(json['id'], 'tm_3');
      expect(json['title'], 'Test');
      expect(json['metadata'], {'custom': true});
    });
  });

  group('Page', () {
    test('fromJson with int items', () {
      final json = {
        'data': [1, 2, 3],
        'has_more': true,
        'after': 'cursor_1',
      };

      final page = Page.fromJson(json, (item) => item as int);
      expect(page.data, [1, 2, 3]);
      expect(page.hasMore, true);
      expect(page.after, 'cursor_1');
    });

    test('fromJson with no cursor', () {
      final json = {
        'data': <dynamic>[],
        'has_more': false,
      };

      final page = Page.fromJson(json, (item) => item as int);
      expect(page.data, isEmpty);
      expect(page.hasMore, false);
      expect(page.after, isNull);
    });

    test('toJson', () {
      const page = Page(data: [1, 2], hasMore: true, after: 'c1');
      final json = page.toJson((item) => item);
      expect(json['data'], [1, 2]);
      expect(json['has_more'], true);
      expect(json['after'], 'c1');
    });

    test('toJson omits after when null', () {
      const page = Page(data: <int>[], hasMore: false);
      final json = page.toJson((item) => item);
      expect(json.containsKey('after'), false);
    });

    test('copyWith', () {
      const page = Page(data: [1, 2, 3], hasMore: true, after: 'c1');
      final updated = page.copyWith(hasMore: false);
      expect(updated.data, [1, 2, 3]);
      expect(updated.hasMore, false);
      expect(updated.after, 'c1');
    });
  });

  group('Attachment', () {
    test('FileAttachment fromJson', () {
      final json = {
        'type': 'file',
        'id': 'att_1',
        'name': 'report.pdf',
        'mime_type': 'application/pdf',
      };

      final att = Attachment.fromJson(json);
      expect(att, isA<FileAttachment>());
      expect(att.name, 'report.pdf');
      expect(att.mimeType, 'application/pdf');
      expect(att.type, 'file');
    });

    test('ImageAttachment fromJson', () {
      final json = {
        'type': 'image',
        'id': 'att_2',
        'name': 'photo.jpg',
        'mime_type': 'image/jpeg',
        'preview_url': 'https://example.com/preview.jpg',
      };

      final att = Attachment.fromJson(json) as ImageAttachment;
      expect(att.previewUrl, 'https://example.com/preview.jpg');
      expect(att.type, 'image');
    });

    test('FileAttachment with upload descriptor', () {
      final json = {
        'type': 'file',
        'id': 'att_3',
        'name': 'file.txt',
        'mime_type': 'text/plain',
        'upload_descriptor': {
          'url': 'https://upload.example.com',
          'method': 'PUT',
          'headers': {'Authorization': 'Bearer xyz'},
        },
      };

      final att = Attachment.fromJson(json) as FileAttachment;
      expect(att.uploadDescriptor, isNotNull);
      expect(att.uploadDescriptor!.url, 'https://upload.example.com');
      expect(att.uploadDescriptor!.method, 'PUT');
      expect(att.uploadDescriptor!.headers['Authorization'], 'Bearer xyz');
    });

    test('FileAttachment toJson roundtrip', () {
      final json = {
        'type': 'file',
        'id': 'att_4',
        'name': 'doc.txt',
        'mime_type': 'text/plain',
        'thread_id': 'thread_1',
        'metadata': {'pages': 10},
      };

      final att = Attachment.fromJson(json) as FileAttachment;
      final output = att.toJson();
      expect(output['type'], 'file');
      expect(output['id'], 'att_4');
      expect(output['thread_id'], 'thread_1');
      expect(output['metadata'], {'pages': 10});
    });

    test('ImageAttachment toJson roundtrip', () {
      final json = {
        'type': 'image',
        'id': 'att_5',
        'name': 'img.png',
        'mime_type': 'image/png',
        'preview_url': 'https://example.com/p.png',
      };

      final att = Attachment.fromJson(json) as ImageAttachment;
      final output = att.toJson();
      expect(output['preview_url'], 'https://example.com/p.png');
    });

    test('throws on unknown attachment type', () {
      expect(
        () => Attachment.fromJson({
          'type': 'video',
          'id': 'att_x',
          'name': 'clip.mp4',
          'mime_type': 'video/mp4',
        }),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('FileAttachment toJson omits optional null fields', () {
      const att = FileAttachment(
        id: 'att_6',
        name: 'minimal.txt',
        mimeType: 'text/plain',
      );

      final json = att.toJson();
      expect(json.containsKey('thread_id'), false);
      expect(json.containsKey('upload_descriptor'), false);
      expect(json.containsKey('metadata'), false);
    });
  });

  group('AttachmentUploadDescriptor', () {
    test('fromJson and toJson', () {
      final json = {
        'url': 'https://upload.example.com',
        'method': 'POST',
        'headers': {'Content-Type': 'multipart/form-data'},
      };

      final desc = AttachmentUploadDescriptor.fromJson(json);
      expect(desc.url, 'https://upload.example.com');
      expect(desc.method, 'POST');

      final output = desc.toJson();
      expect(output['url'], 'https://upload.example.com');
      expect(output['method'], 'POST');
      expect(output['headers'], {'Content-Type': 'multipart/form-data'});
    });

    test('defaults to empty headers', () {
      final json = {
        'url': 'https://example.com',
        'method': 'PUT',
      };

      final desc = AttachmentUploadDescriptor.fromJson(json);
      expect(desc.headers, isEmpty);
    });

    test('toJson omits empty headers', () {
      const desc = AttachmentUploadDescriptor(
        url: 'https://example.com',
        method: 'PUT',
      );

      final json = desc.toJson();
      expect(json.containsKey('headers'), false);
    });
  });

  group('Source', () {
    test('UrlSource fromJson and toJson', () {
      final json = {
        'type': 'url',
        'url': 'https://example.com',
        'title': 'Example',
        'description': 'A site',
        'attribution': 'Author',
      };

      final source = Source.fromJson(json);
      expect(source, isA<UrlSource>());
      final urlSource = source as UrlSource;
      expect(urlSource.url, 'https://example.com');
      expect(urlSource.title, 'Example');
      expect(urlSource.description, 'A site');
      expect(urlSource.attribution, 'Author');

      final output = urlSource.toJson();
      expect(output['type'], 'url');
      expect(output['url'], 'https://example.com');
    });

    test('FileSource fromJson and toJson', () {
      final json = {
        'type': 'file',
        'filename': 'doc.pdf',
        'title': 'Document',
      };

      final source = Source.fromJson(json);
      expect(source, isA<FileSource>());
      final fileSource = source as FileSource;
      expect(fileSource.filename, 'doc.pdf');
      expect(fileSource.title, 'Document');

      final output = fileSource.toJson();
      expect(output['type'], 'file');
      expect(output['filename'], 'doc.pdf');
    });

    test('EntitySource fromJson and toJson', () {
      final json = {
        'type': 'entity',
        'id': 'ent_1',
        'label': 'John',
        'icon': 'person',
        'inline_label': 'J',
        'interactive': true,
        'data': {'role': 'admin'},
      };

      final source = Source.fromJson(json);
      expect(source, isA<EntitySource>());
      final entitySource = source as EntitySource;
      expect(entitySource.entityId, 'ent_1');
      expect(entitySource.label, 'John');
      expect(entitySource.icon, 'person');
      expect(entitySource.inlineLabel, 'J');
      expect(entitySource.interactive, true);
      expect(entitySource.data, {'role': 'admin'});

      final output = entitySource.toJson();
      expect(output['type'], 'entity');
      expect(output['id'], 'ent_1');
    });

    test('throws on unknown source type', () {
      expect(
        () => Source.fromJson({'type': 'unknown'}),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('UrlSource toJson omits null optional fields', () {
      const source = UrlSource(url: 'https://example.com');
      final json = source.toJson();
      expect(json.containsKey('title'), false);
      expect(json.containsKey('description'), false);
      expect(json.containsKey('timestamp'), false);
      expect(json.containsKey('group'), false);
      expect(json.containsKey('attribution'), false);
    });

    test('EntitySource defaults interactive to false', () {
      final json = {
        'type': 'entity',
        'id': 'ent_2',
      };

      final source = Source.fromJson(json) as EntitySource;
      expect(source.interactive, false);
    });
  });

  group('Annotation', () {
    test('fromJson and toJson', () {
      final json = {
        'type': 'url_citation',
        'source': {
          'type': 'url',
          'url': 'https://example.com',
          'title': 'Example',
        },
        'index': 5,
      };

      final annotation = Annotation.fromJson(json);
      expect(annotation.type, 'url_citation');
      expect(annotation.index, 5);
      expect(annotation.source, isA<UrlSource>());

      final output = annotation.toJson();
      expect(output['type'], 'url_citation');
      expect(output['index'], 5);
    });

    test('toJson omits index when null', () {
      final json = {
        'type': 'citation',
        'source': {
          'type': 'file',
          'filename': 'doc.pdf',
        },
      };

      final annotation = Annotation.fromJson(json);
      expect(annotation.index, isNull);

      final output = annotation.toJson();
      expect(output.containsKey('index'), false);
    });
  });

  group('UserMessageContent', () {
    test('UserMessageTextContent toJson', () {
      const content = UserMessageTextContent(text: 'Hello');
      final json = content.toJson();
      expect(json['type'], 'input_text');
      expect(json['text'], 'Hello');
    });

    test('UserMessageTagContent toJson', () {
      const content = UserMessageTagContent(
        id: 'e1',
        text: '@John',
        interactive: true,
      );
      final json = content.toJson();
      expect(json['type'], 'input_tag');
      expect(json['id'], 'e1');
      expect(json['text'], '@John');
      expect(json['interactive'], true);
    });

    test('UserMessageTagContent toJson omits null optional fields', () {
      const content = UserMessageTagContent(id: 'e2', text: '@Team');
      final json = content.toJson();
      expect(json.containsKey('data'), false);
      expect(json.containsKey('group'), false);
    });
  });

  group('UserMessageInput', () {
    test('toJson minimal', () {
      const input = UserMessageInput(
        content: [UserMessageTextContent(text: 'Hi')],
      );

      final json = input.toJson();
      expect(json['content'], isA<List>());
      expect(json.containsKey('attachments'), false);
      expect(json.containsKey('quoted_text'), false);
      expect(json.containsKey('inference_options'), false);
    });

    test('toJson with all fields', () {
      const input = UserMessageInput(
        content: [UserMessageTextContent(text: 'Hi')],
        attachments: [
          FileAttachment(
            id: 'a1',
            name: 'file.txt',
            mimeType: 'text/plain',
          ),
        ],
        quotedText: 'Previous message',
        inferenceOptions: InferenceOptions(model: 'gpt-4'),
      );

      final json = input.toJson();
      expect(json.containsKey('attachments'), true);
      expect(json['quoted_text'], 'Previous message');
      expect(json['inference_options']['model'], 'gpt-4');
    });
  });

  group('InferenceOptions', () {
    test('fromJson with tool choice', () {
      final json = {
        'tool_choice': {'id': 'tool_1'},
        'model': 'gpt-4-turbo',
      };

      final options = InferenceOptions.fromJson(json);
      expect(options.toolChoice!.id, 'tool_1');
      expect(options.model, 'gpt-4-turbo');
    });

    test('fromJson minimal', () {
      final json = <String, dynamic>{};
      final options = InferenceOptions.fromJson(json);
      expect(options.toolChoice, isNull);
      expect(options.model, isNull);
    });

    test('toJson omits null fields', () {
      const options = InferenceOptions();
      final json = options.toJson();
      expect(json.containsKey('tool_choice'), false);
      expect(json.containsKey('model'), false);
    });
  });

  group('Entity', () {
    test('fromJson', () {
      final json = {
        'id': 'ent_1',
        'label': 'John Doe',
        'icon': 'person',
        'inline_label': 'JD',
        'interactive': true,
        'data': {'email': 'john@example.com'},
        'group': 'people',
      };

      final entity = Entity.fromJson(json);
      expect(entity.id, 'ent_1');
      expect(entity.label, 'John Doe');
      expect(entity.icon, 'person');
      expect(entity.inlineLabel, 'JD');
      expect(entity.interactive, true);
      expect(entity.data, {'email': 'john@example.com'});
      expect(entity.group, 'people');
    });

    test('toJson omits null optional fields', () {
      const entity = Entity(id: 'ent_2', label: 'Minimal');
      final json = entity.toJson();
      expect(json['id'], 'ent_2');
      expect(json['label'], 'Minimal');
      expect(json.containsKey('icon'), false);
      expect(json.containsKey('inline_label'), false);
      expect(json.containsKey('data'), false);
      expect(json.containsKey('group'), false);
      expect(json['interactive'], false);
    });
  });
}
