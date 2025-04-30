class PaginatedResponse<T> {
  final List<T> products;
  final int currentPage;
  final int totalPages;
  final int totalProducts;

  PaginatedResponse({
    required this.products,
    required this.currentPage,
    required this.totalPages,
    required this.totalProducts,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return PaginatedResponse(
      products: (json['products'] as List)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalProducts: json['totalProducts'],
    );
  }
}