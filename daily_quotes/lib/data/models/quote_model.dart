class Quote {
  final String? id;
  final String text; // mapped from content
  final String author;
  final String? categoryId;
  final bool isLiked; // backend might send this if auth
  final bool isFavorited;
  final int likesCount;

  Quote({
    this.id,
    required this.text,
    required this.author,
    this.categoryId,
    this.isLiked = false,
    this.isFavorited = false,
    this.likesCount = 0,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      // Backend uses 'content', others use 'q'/'quote'
      text: json['content'] ?? json['text'] ?? json['q'] ?? json['quote'] ?? 'Unknown Quote',
      author: json['author'] ?? json['a'] ?? 'Unknown Author',
      categoryId: json['category_id'],
      isLiked: json['is_liked'] ?? false,
      isFavorited: json['is_favorited'] ?? false,
      likesCount: json['likes_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': text,
      'text': text,
      'author': author,
      'category_id': categoryId,
    };
  }
}
