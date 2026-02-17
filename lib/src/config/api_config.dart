/// Base class for API configuration
sealed class ApiConfig {
  const ApiConfig();
}

/// Configuration for OpenAI-hosted ChatKit backend
class HostedApiConfig extends ApiConfig {
  const HostedApiConfig({
    required this.getClientSecret,
    this.baseUrl = 'https://api.openai.com/v1',
  });

  /// Async callback that returns a client secret token.
  /// Receives the existing secret (if any) for refresh scenarios.
  final Future<String> Function(String? existingSecret) getClientSecret;
  final String baseUrl;
}

/// Configuration for self-hosted ChatKit backend
class CustomApiConfig extends ApiConfig {
  const CustomApiConfig({
    required this.url,
    this.headers = const {},
  });

  /// Base URL of the self-hosted ChatKit server
  final String url;

  /// Additional headers to include in requests
  final Map<String, String> headers;
}
