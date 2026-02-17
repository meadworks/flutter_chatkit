import 'dart:async';

/// Manages client secret tokens for the hosted API.
/// Handles token refresh when expired.
class TokenManager {
  TokenManager({required this.getClientSecret});

  final Future<String> Function(String? existingSecret) getClientSecret;

  String? _currentSecret;
  bool _refreshing = false;
  final List<Completer<String>> _pendingRefreshes = [];

  /// Get a valid token, refreshing if needed
  Future<String> getToken() async {
    if (_currentSecret != null) {
      return _currentSecret!;
    }
    return _refreshToken();
  }

  /// Force a token refresh
  Future<String> refreshToken() => _refreshToken();

  Future<String> _refreshToken() async {
    if (_refreshing) {
      // Wait for the in-progress refresh
      final completer = Completer<String>();
      _pendingRefreshes.add(completer);
      return completer.future;
    }

    _refreshing = true;
    try {
      final secret = await getClientSecret(_currentSecret);
      _currentSecret = secret;

      // Resolve all pending waiters
      for (final completer in _pendingRefreshes) {
        completer.complete(secret);
      }
      _pendingRefreshes.clear();

      return secret;
    } catch (e) {
      // Reject all pending waiters
      for (final completer in _pendingRefreshes) {
        completer.completeError(e);
      }
      _pendingRefreshes.clear();
      rethrow;
    } finally {
      _refreshing = false;
    }
  }

  /// Clear the current token
  void clearToken() {
    _currentSecret = null;
  }
}
