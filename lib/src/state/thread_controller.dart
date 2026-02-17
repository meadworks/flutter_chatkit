import 'package:flutter/foundation.dart';
import '../models/thread.dart';
import '../client/chat_kit_client.dart';
import '../client/request_types.dart';

/// Manages the thread list and active thread selection
class ThreadController extends ChangeNotifier {
  ThreadController({required this.client, this.pageSize = 20});

  final ChatKitClient client;
  final int pageSize;

  List<ThreadMetadata> _threads = [];
  List<ThreadMetadata> get threads => _threads;

  String? _activeThreadId;
  String? get activeThreadId => _activeThreadId;

  Thread? _activeThread;
  Thread? get activeThread => _activeThread;

  bool _isLoadingThreads = false;
  bool get isLoadingThreads => _isLoadingThreads;

  bool _hasMoreThreads = true;
  bool get hasMoreThreads => _hasMoreThreads;

  String? _lastThreadCursor;

  /// Load the initial list of threads
  Future<void> loadThreads() async {
    if (_isLoadingThreads) return;
    _isLoadingThreads = true;
    notifyListeners();

    try {
      final page = await client.listThreads(
        ThreadListRequest(limit: pageSize),
      );
      _threads = page.data;
      _hasMoreThreads = page.hasMore;
      _lastThreadCursor = page.after;
    } catch (e) {
      // Error loading threads
    } finally {
      _isLoadingThreads = false;
      notifyListeners();
    }
  }

  /// Load more threads (pagination)
  Future<void> loadMoreThreads() async {
    if (_isLoadingThreads || !_hasMoreThreads) return;
    _isLoadingThreads = true;
    notifyListeners();

    try {
      final page = await client.listThreads(
        ThreadListRequest(limit: pageSize, after: _lastThreadCursor),
      );
      _threads = [..._threads, ...page.data];
      _hasMoreThreads = page.hasMore;
      _lastThreadCursor = page.after;
    } catch (e) {
      // Error loading more threads
    } finally {
      _isLoadingThreads = false;
      notifyListeners();
    }
  }

  /// Set the active thread by ID (fetches full thread from API)
  Future<void> setActiveThread(String threadId) async {
    _activeThreadId = threadId;
    notifyListeners();

    try {
      _activeThread = await client.getThread(
        ThreadGetByIdRequest(threadId: threadId),
      );
      notifyListeners();
    } catch (e) {
      _activeThread = null;
      notifyListeners();
    }
  }

  /// Set active thread directly (used by ChatKitController during stream processing)
  void setActiveThreadDirect(String id, Thread thread) {
    _activeThreadId = id;
    _activeThread = thread;
    notifyListeners();
  }

  /// Clear the active thread (go back to start screen)
  void clearActiveThread() {
    _activeThreadId = null;
    _activeThread = null;
    notifyListeners();
  }

  /// Update thread metadata in the list after creation/update
  void upsertThread(ThreadMetadata metadata) {
    final index = _threads.indexWhere((t) => t.id == metadata.id);
    if (index >= 0) {
      _threads = List.from(_threads)..[index] = metadata;
    } else {
      _threads = [metadata, ..._threads];
    }
    notifyListeners();
  }

  /// Remove a thread from the list
  void removeThread(String threadId) {
    _threads = _threads.where((t) => t.id != threadId).toList();
    if (_activeThreadId == threadId) {
      clearActiveThread();
    }
    notifyListeners();
  }

  /// Update thread title
  Future<void> updateThreadTitle(String threadId, String title) async {
    await client.updateThread(
      ThreadUpdateRequest(threadId: threadId, title: title),
    );
    final index = _threads.indexWhere((t) => t.id == threadId);
    if (index >= 0) {
      _threads = List.from(_threads)
        ..[index] = _threads[index].copyWith(title: title);
      notifyListeners();
    }
  }

  /// Delete a thread
  Future<void> deleteThread(String threadId) async {
    await client.deleteThread(ThreadDeleteRequest(threadId: threadId));
    removeThread(threadId);
  }
}
