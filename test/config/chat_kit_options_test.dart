import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chatkit/flutter_chatkit.dart';

void main() {
  group('ApiConfig', () {
    test('CustomApiConfig holds url and headers', () {
      const config = CustomApiConfig(
        url: 'http://localhost:8000',
        headers: {'X-Api-Key': 'abc'},
      );

      expect(config.url, 'http://localhost:8000');
      expect(config.headers['X-Api-Key'], 'abc');
    });

    test('CustomApiConfig defaults headers to empty', () {
      const config = CustomApiConfig(url: 'http://localhost');
      expect(config.headers, isEmpty);
    });

    test('HostedApiConfig holds baseUrl and callback', () async {
      final config = HostedApiConfig(
        getClientSecret: (_) async => 'secret_123',
        baseUrl: 'https://custom.api.com/v1',
      );

      expect(config.baseUrl, 'https://custom.api.com/v1');
      final secret = await config.getClientSecret(null);
      expect(secret, 'secret_123');
    });

    test('HostedApiConfig defaults to OpenAI base URL', () {
      final config = HostedApiConfig(
        getClientSecret: (_) async => 'secret',
      );

      expect(config.baseUrl, 'https://api.openai.com/v1');
    });

    test('ApiConfig subtypes are sealed', () {
      const ApiConfig custom = CustomApiConfig(url: 'http://localhost');
      expect(custom, isA<ApiConfig>());
      expect(custom, isA<CustomApiConfig>());
    });
  });

  group('ChatKitOptions', () {
    test('creates with CustomApiConfig', () {
      final options = ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost:8000'),
      );

      expect(options.api, isA<CustomApiConfig>());
      expect((options.api as CustomApiConfig).url, 'http://localhost:8000');
    });

    test('creates with HostedApiConfig', () {
      final options = ChatKitOptions(
        api: HostedApiConfig(
          getClientSecret: (_) async => 'token',
        ),
      );

      expect(options.api, isA<HostedApiConfig>());
    });

    test('has sensible defaults for header', () {
      final options = ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost'),
      );

      expect(options.header.showTitle, true);
      expect(options.header.showHistoryButton, true);
      expect(options.header.showModelPicker, false);
      expect(options.header.title, isNull);
    });

    test('has sensible defaults for history', () {
      final options = ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost'),
      );

      expect(options.history.enabled, true);
      expect(options.history.pageSize, 20);
    });

    test('has sensible defaults for composer', () {
      final options = ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost'),
      );

      expect(options.composer.fileUpload.enabled, true);
      expect(options.composer.fileUpload.maxFileSize, 10 * 1024 * 1024);
      expect(options.composer.fileUpload.allowedMimeTypes, isEmpty);
      expect(options.composer.showToolPicker, false);
      expect(options.composer.showModelPicker, false);
      expect(options.composer.placeholder, isNull);
    });

    test('has sensible defaults for disclaimer', () {
      final options = ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost'),
      );

      expect(options.disclaimer.enabled, false);
      expect(options.disclaimer.text, isNull);
    });

    test('has sensible defaults for entities', () {
      final options = ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost'),
      );

      expect(options.entities.enabled, false);
      expect(options.entities.entities, isEmpty);
    });

    test('has sensible defaults for threadItemActions', () {
      final options = ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost'),
      );

      expect(options.threadItemActions.showFeedback, true);
      expect(options.threadItemActions.showCopy, true);
      expect(options.threadItemActions.showRetry, true);
    });

    test('accepts custom header option', () {
      final options = ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost'),
        header: HeaderOption(
          title: 'My Chat',
          showTitle: false,
          showModelPicker: true,
          showHistoryButton: false,
        ),
      );

      expect(options.header.title, 'My Chat');
      expect(options.header.showTitle, false);
      expect(options.header.showModelPicker, true);
      expect(options.header.showHistoryButton, false);
    });

    test('accepts custom history option', () {
      final options = ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost'),
        history: HistoryOption(enabled: false, pageSize: 50),
      );

      expect(options.history.enabled, false);
      expect(options.history.pageSize, 50);
    });

    test('accepts custom disclaimer option', () {
      final options = ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost'),
        disclaimer: DisclaimerOption(
          enabled: true,
          text: 'AI can make mistakes.',
        ),
      );

      expect(options.disclaimer.enabled, true);
      expect(options.disclaimer.text, 'AI can make mistakes.');
    });

    test('accepts custom thread item actions', () {
      final options = ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost'),
        threadItemActions: ThreadItemActionsOption(
          showFeedback: false,
          showCopy: false,
          showRetry: false,
        ),
      );

      expect(options.threadItemActions.showFeedback, false);
      expect(options.threadItemActions.showCopy, false);
      expect(options.threadItemActions.showRetry, false);
    });

    test('accepts custom composer with file upload config', () {
      final options = ChatKitOptions(
        api: CustomApiConfig(url: 'http://localhost'),
        composer: ComposerOption(
          placeholder: 'Ask me anything...',
          fileUpload: FileUploadOption(
            enabled: false,
            maxFileSize: 5 * 1024 * 1024,
            allowedMimeTypes: ['image/png', 'image/jpeg'],
          ),
          showToolPicker: true,
        ),
      );

      expect(options.composer.placeholder, 'Ask me anything...');
      expect(options.composer.fileUpload.enabled, false);
      expect(options.composer.fileUpload.maxFileSize, 5 * 1024 * 1024);
      expect(
        options.composer.fileUpload.allowedMimeTypes,
        ['image/png', 'image/jpeg'],
      );
      expect(options.composer.showToolPicker, true);
    });
  });

  group('StartScreenOption', () {
    test('default values', () {
      const option = StartScreenOption();
      expect(option.greeting, isNull);
      expect(option.suggestedPrompts, isEmpty);
    });

    test('holds greeting and prompts', () {
      final option = StartScreenOption(
        greeting: 'Hello!',
        suggestedPrompts: [
          SuggestedPrompt(label: 'Test', prompt: 'test prompt'),
          SuggestedPrompt(
            label: 'With Icon',
            prompt: 'icon prompt',
            icon: 'star',
          ),
        ],
      );

      expect(option.greeting, 'Hello!');
      expect(option.suggestedPrompts.length, 2);
      expect(option.suggestedPrompts[0].label, 'Test');
      expect(option.suggestedPrompts[0].prompt, 'test prompt');
      expect(option.suggestedPrompts[0].icon, isNull);
      expect(option.suggestedPrompts[1].icon, 'star');
    });
  });

  group('SuggestedPrompt', () {
    test('holds label, prompt, and optional icon', () {
      const prompt = SuggestedPrompt(
        label: 'Help me write',
        prompt: 'Help me write a professional email',
        icon: 'edit',
      );

      expect(prompt.label, 'Help me write');
      expect(prompt.prompt, 'Help me write a professional email');
      expect(prompt.icon, 'edit');
    });
  });

  group('FileUploadOption', () {
    test('default values', () {
      const option = FileUploadOption();
      expect(option.enabled, true);
      expect(option.maxFileSize, 10 * 1024 * 1024);
      expect(option.allowedMimeTypes, isEmpty);
    });
  });

  group('EntitiesOption', () {
    test('default values', () {
      const option = EntitiesOption();
      expect(option.enabled, false);
      expect(option.entities, isEmpty);
    });

    test('with entities', () {
      final option = EntitiesOption(
        enabled: true,
        entities: [
          Entity(id: 'e1', label: 'User 1'),
          Entity(id: 'e2', label: 'User 2'),
        ],
      );

      expect(option.enabled, true);
      expect(option.entities.length, 2);
    });
  });
}
