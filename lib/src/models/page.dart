/// Generic cursor-based pagination wrapper.
///
/// Used to represent paginated responses from the ChatKit backend.
/// The [after] cursor can be passed to subsequent requests to fetch
/// the next page of results.
class Page<T> {
  const Page({
    required this.data,
    required this.hasMore,
    this.after,
  });

  /// The list of items in this page.
  final List<T> data;

  /// Whether there are more items available after this page.
  final bool hasMore;

  /// Cursor to pass to the next request to fetch the next page.
  /// Null if [hasMore] is false.
  final String? after;

  /// Deserializes a [Page] from JSON.
  ///
  /// The [fromJsonT] function is used to deserialize each item in the
  /// `data` array.
  factory Page.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return Page(
      data: (json['data'] as List).map(fromJsonT).toList(),
      hasMore: json['has_more'] as bool,
      after: json['after'] as String?,
    );
  }

  /// Serializes this [Page] to JSON.
  ///
  /// The [toJsonT] function is used to serialize each item in the
  /// [data] list.
  Map<String, dynamic> toJson(dynamic Function(T) toJsonT) => {
        'data': data.map(toJsonT).toList(),
        'has_more': hasMore,
        if (after != null) 'after': after,
      };

  /// Creates a copy of this [Page] with the given fields replaced.
  Page<T> copyWith({
    List<T>? data,
    bool? hasMore,
    String? after,
  }) {
    return Page(
      data: data ?? this.data,
      hasMore: hasMore ?? this.hasMore,
      after: after ?? this.after,
    );
  }
}
