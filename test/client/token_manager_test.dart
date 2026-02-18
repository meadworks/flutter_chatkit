import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat_kit_ui/flutter_chat_kit_ui.dart';

void main() {
  group('TokenManager', () {
    test('gets initial token by calling getClientSecret', () async {
      final manager = TokenManager(
        getClientSecret: (existing) async => 'token_123',
      );

      final token = await manager.getToken();
      expect(token, 'token_123');
    });

    test('passes null as existing secret on first call', () async {
      String? receivedExisting;
      final manager = TokenManager(
        getClientSecret: (existing) async {
          receivedExisting = existing;
          return 'token';
        },
      );

      await manager.getToken();
      expect(receivedExisting, isNull);
    });

    test('caches token after first fetch', () async {
      var callCount = 0;
      final manager = TokenManager(
        getClientSecret: (existing) async {
          callCount++;
          return 'token_$callCount';
        },
      );

      final token1 = await manager.getToken();
      final token2 = await manager.getToken();

      expect(token1, 'token_1');
      expect(token2, 'token_1');
      expect(callCount, 1);
    });

    test('refreshToken forces new token fetch', () async {
      var callCount = 0;
      final manager = TokenManager(
        getClientSecret: (existing) async {
          callCount++;
          return 'token_$callCount';
        },
      );

      final initial = await manager.getToken();
      final refreshed = await manager.refreshToken();

      expect(initial, 'token_1');
      expect(refreshed, 'token_2');
      expect(callCount, 2);
    });

    test('refreshToken passes existing secret to callback', () async {
      String? lastExisting;
      final manager = TokenManager(
        getClientSecret: (existing) async {
          lastExisting = existing;
          return 'token_${existing ?? "new"}';
        },
      );

      await manager.getToken();
      expect(lastExisting, isNull);

      await manager.refreshToken();
      expect(lastExisting, 'token_new');
    });

    test('clearToken forces re-fetch on next getToken', () async {
      var callCount = 0;
      final manager = TokenManager(
        getClientSecret: (existing) async {
          callCount++;
          return 'token_$callCount';
        },
      );

      await manager.getToken();
      expect(callCount, 1);

      manager.clearToken();
      final token = await manager.getToken();

      expect(token, 'token_2');
      expect(callCount, 2);
    });

    test('subsequent getToken after refresh uses new cached token', () async {
      var callCount = 0;
      final manager = TokenManager(
        getClientSecret: (existing) async {
          callCount++;
          return 'token_$callCount';
        },
      );

      await manager.getToken();
      await manager.refreshToken();
      final afterRefresh = await manager.getToken();

      expect(afterRefresh, 'token_2');
      expect(callCount, 2);
    });

    test('concurrent getToken calls coalesce into single fetch', () async {
      var callCount = 0;
      final completer = Completer<String>();
      final manager = TokenManager(
        getClientSecret: (existing) {
          callCount++;
          return completer.future;
        },
      );

      final future1 = manager.getToken();
      final future2 = manager.getToken();

      // First call triggers the fetch, second uses cache because _currentSecret
      // is still null, so second also triggers _refreshToken which deduplicates.
      // However, getToken checks _currentSecret first. Since it is null for both,
      // both call _refreshToken. The second should be queued.

      completer.complete('token_shared');

      final token1 = await future1;
      final token2 = await future2;

      expect(token1, 'token_shared');
      expect(token2, 'token_shared');
      expect(callCount, 1);
    });

    test('concurrent refreshToken calls are coalesced', () async {
      var callCount = 0;
      final completer = Completer<String>();
      final manager = TokenManager(
        getClientSecret: (existing) {
          callCount++;
          if (callCount == 1) return Future.value('first');
          return completer.future;
        },
      );

      await manager.getToken();
      expect(callCount, 1);

      final refresh1 = manager.refreshToken();
      final refresh2 = manager.refreshToken();

      completer.complete('refreshed');

      final result1 = await refresh1;
      final result2 = await refresh2;

      expect(result1, 'refreshed');
      expect(result2, 'refreshed');
      expect(callCount, 2);
    });

    test('error in getClientSecret propagates', () async {
      final manager = TokenManager(
        getClientSecret: (existing) async {
          throw Exception('auth failed');
        },
      );

      expect(
        () => manager.getToken(),
        throwsA(isA<Exception>()),
      );
    });

    test('error during refresh rejects all pending waiters', () async {
      var callCount = 0;
      final manager = TokenManager(
        getClientSecret: (existing) async {
          callCount++;
          if (callCount == 1) return 'initial';
          throw Exception('refresh failed');
        },
      );

      await manager.getToken();

      expect(
        () => manager.refreshToken(),
        throwsA(isA<Exception>()),
      );
    });

    test('can recover after a failed refresh', () async {
      var callCount = 0;
      final manager = TokenManager(
        getClientSecret: (existing) async {
          callCount++;
          if (callCount == 2) throw Exception('temporary failure');
          return 'token_$callCount';
        },
      );

      await manager.getToken();
      expect(callCount, 1);

      // This refresh will fail
      try {
        await manager.refreshToken();
      } catch (_) {}
      expect(callCount, 2);

      // Next refresh should work because _refreshing was reset in finally
      final recovered = await manager.refreshToken();
      expect(recovered, 'token_3');
      expect(callCount, 3);
    });

    test('clearToken then getToken calls callback with null existing', () async {
      String? receivedExisting = 'sentinel';
      var callCount = 0;
      final manager = TokenManager(
        getClientSecret: (existing) async {
          callCount++;
          receivedExisting = existing;
          return 'token_$callCount';
        },
      );

      await manager.getToken();
      manager.clearToken();
      await manager.getToken();

      // After clearToken, _currentSecret is null, so the callback receives
      // whatever _currentSecret is (null after clear)
      expect(receivedExisting, isNull);
    });
  });
}
