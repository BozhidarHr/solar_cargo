class PagingResponse<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  PagingResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PagingResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) {
    return PagingResponse<T>(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>)
          .map<T>((item) => fromJsonT(item))
          .toList(),
    );
  }
}