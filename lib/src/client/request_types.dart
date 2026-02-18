import '../models/thread_item.dart';

/// Base request metadata
class RequestMetadata {
  const RequestMetadata({this.metadata = const {}});
  final Map<String, dynamic> metadata;
}

/// Create a new thread with an initial message
class ThreadCreateRequest {
  const ThreadCreateRequest({required this.input, this.metadata = const {}});
  final UserMessageInput input;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() => {
    'type': 'threads.create',
    'params': {
      'input': input.toJson(),
    },
    if (metadata.isNotEmpty) 'metadata': metadata,
  };
}

/// Add a user message to an existing thread
class ThreadAddMessageRequest {
  const ThreadAddMessageRequest({
    required this.threadId,
    required this.input,
  });
  final String threadId;
  final UserMessageInput input;

  Map<String, dynamic> toJson() => {
    'type': 'threads.add_user_message',
    'params': {
      'thread_id': threadId,
      'input': input.toJson(),
    },
  };
}

/// Submit client tool call output
class ThreadAddToolOutputRequest {
  const ThreadAddToolOutputRequest({
    required this.threadId,
    required this.result,
  });
  final String threadId;
  final Map<String, dynamic> result;

  Map<String, dynamic> toJson() => {
    'type': 'threads.add_client_tool_output',
    'params': {
      'thread_id': threadId,
      'result': result,
    },
  };
}

/// Retry from a specific item
class ThreadRetryRequest {
  const ThreadRetryRequest({
    required this.threadId,
    required this.itemId,
  });
  final String threadId;
  final String itemId;

  Map<String, dynamic> toJson() => {
    'type': 'threads.retry_after_item',
    'params': {
      'thread_id': threadId,
      'item_id': itemId,
    },
  };
}

/// Execute a custom widget action
class ThreadCustomActionRequest {
  const ThreadCustomActionRequest({
    required this.threadId,
    required this.itemId,
    required this.action,
  });
  final String threadId;
  final String itemId;
  final Map<String, dynamic> action;

  Map<String, dynamic> toJson() => {
    'type': 'threads.custom_action',
    'params': {
      'thread_id': threadId,
      'item_id': itemId,
      'action': action,
    },
  };
}

/// Get thread by ID (non-streaming)
class ThreadGetByIdRequest {
  const ThreadGetByIdRequest({required this.threadId});
  final String threadId;
}

/// List threads (non-streaming)
class ThreadListRequest {
  const ThreadListRequest({
    this.limit = 20,
    this.order = 'desc',
    this.after,
  });
  final int limit;
  final String order;
  final String? after;
}

/// List items in a thread (non-streaming)
class ItemsListRequest {
  const ItemsListRequest({
    required this.threadId,
    this.limit = 50,
    this.order = 'asc',
    this.after,
  });
  final String threadId;
  final int limit;
  final String order;
  final String? after;
}

/// Submit feedback on thread items
class ItemsFeedbackRequest {
  const ItemsFeedbackRequest({
    required this.threadId,
    required this.itemIds,
    required this.kind,
  });
  final String threadId;
  final List<String> itemIds;
  final String kind; // 'positive' or 'negative'

  Map<String, dynamic> toJson() => {
    'thread_id': threadId,
    'item_ids': itemIds,
    'kind': kind,
  };
}

/// Create an attachment upload descriptor
class AttachmentCreateRequest {
  const AttachmentCreateRequest({
    required this.name,
    required this.size,
    required this.mimeType,
  });
  final String name;
  final int size;
  final String mimeType;

  Map<String, dynamic> toJson() => {
    'name': name,
    'size': size,
    'mime_type': mimeType,
  };
}

/// Delete an attachment
class AttachmentDeleteRequest {
  const AttachmentDeleteRequest({required this.attachmentId});
  final String attachmentId;
}

/// Update thread title
class ThreadUpdateRequest {
  const ThreadUpdateRequest({
    required this.threadId,
    required this.title,
  });
  final String threadId;
  final String title;
}

/// Delete a thread
class ThreadDeleteRequest {
  const ThreadDeleteRequest({required this.threadId});
  final String threadId;
}
